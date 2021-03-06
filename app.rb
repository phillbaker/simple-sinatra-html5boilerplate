require 'rubygems'
require 'bundler/setup'

require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/assetpack'
require 'sinatra/advanced_routes'

require 'less'
require 'uglifier'

require 'rack/csrf'

require 'lib/sinatra/erector'
require 'lib/sinatra/assetpackhelpers'

class App < Sinatra::Base
  set :root, File.dirname(__FILE__)
  set :app_file, __FILE__
  set :views, File.join('app', 'views')
  # set :environment, :production #For production testing
  # Add the views directory to the 'require' LOAD_PATH for erector templates to work
  $: << settings.views
  # Use ./public for static files
  set :logging, true
  register Sinatra::AssetPack
  
  configure :development do
    register Sinatra::Reloader
  end

  assets do
    serve '/js',     :from => 'app/js'
    serve '/css',    :from => 'app/css'
    serve '/images', :from => File.join('public', 'images')

    # The (optional) second parameter defines where the compressed version will be served.
    # The third is the list of files to concatenate and minify
    js :head, '/js/head.js', [
      '/js/libs/modernizr-2.0.6.min.js'
    ]

    js :lib, '/js/lib.js', [
      '/js/libs/jquery-1.6.2.js'
    ]
    
    js :app, '/js/app.js', [
      '/js/opt/bootstrap-2.0.2.js',
      '/js/plugins.js',
      '/js/script.js'
    ]
    
    #for .less files name by .css
    #don't really like the redundancy and the trick of calling the file by it's translated name
    css :application, '/css/application.css', [
      '/css/h5bp.css',
      '/css/bootstrap.css'#,
      #'/css/bootstrap-responsive.css',
      # '/css/bootstrap.aggregated.css',
      #'/css/app.less'
    ]

    js_compression  :uglify
    css_compression :less
  end
  
  helpers do
    include Rack::Utils
    #returns a hash with paths as keys and route info in another hash keyed by name/value pairs
    def routes
      routes = {}
      self.class.each_route do |route|
        #routes[:name] = route.app.name   # "SomeSinatraApp"
        info = {}
        routes[route.path.to_s.to_sym] = info        # that's the path given as argument to get and akin
        info[:verb] = route.verb       # get / head / post / put / delete
        info[:file] = route.file       # "some_sinatra_app.rb" or something
        info[:line] = route.line       # the line number of the get/post/... statement
        info[:pattern] = route.pattern    # that's the pattern internally used by sinatra
        info[:keys] = route.keys       # keys given when route was defined
        info[:conditions] = route.conditions # conditions given when route was defined
        info[:block] = route.block      # the route's closure
      end
      routes
    end
  end

  not_found do
    # The HTML5 Boilerplate's 404.html is easier to understand than the default Sinatra 404-message.
    # However, this should probably be changed to some view using your own layout, and your own message.
    #settings.public
    File.read(File.join('public', '404.html'))
  end

  #TODO fix problems with layouts (turn them off for the template or somehow use them just for the 'require')
  get '/' do
    @title = "Hello world!"
    @content = "Foo bar. - #{RACK_ENV if defined? RACK_ENV}"
    erector :index, :locals => {:title => @title, :content => @content}, :layout => false
  end
  
  #TODO get this working
  get '/inline' do
    erector do
      p do
        text 'text'
      end
    end
  end
  
  run! if app_file == $0
end
