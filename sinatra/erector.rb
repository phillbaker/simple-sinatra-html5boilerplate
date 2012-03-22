#################################################
######### Tilt and Sinatra integration
#################################################

require 'sinatra/base'
require 'erector'

module Sinatra
  # class Base
  #   helpers do
  #     def erector(*args) 
  #       render(:erector, *args) 
  #     end
  #   end
  # end

  module Templates
    def erector(template, options={}, locals={})
      #puts settings.environment == :development #TODO put in a reference to the sinatra object, pass in self
      options[:environment] ||= settings.environment
      #options[:sinatra] ||= self
      render :rb, template, options, locals #use the rb extension, tilt recognizes this
    end
  end
end

class Erector::Widgets::Page
  class<<self
    attr_accessor :scope
  end
end

#TODO separate these into different files?
require 'tilt/template'

module Tilt
  # Erector
  # https://github.com/pivotal/erector
  
  # Based on http://stackoverflow.com/questions/5960381/sinatra-render-a-ruby-file
  #  and Markaby's Tilt template
  # See https://github.com/rtomayko/tilt/pull/110
  class ErectorTemplate < Template
    def prepare
    end

    def self.engine_initialized?
      defined? ::Erector
    end

    def initialize_engine
      require_template_library 'erector'
    end

    def evaluate(scope, locals, &block)
      #super(scope, locals, &block)
      #TODO use @data ? (template file)
      #if we get passed a block, is it always because we're using a layout? And the block is content? => not necessarily
      
      Erector::Widgets::Page.scope = scope
      Erector::Widgets::Page.class_eval <<-RUBY
        class<<self
          def method_missing(meth, *args, &block)
            scope = Erector::Widgets::Page.scope
            if scope.respond_to? meth
              scope.send(meth, *args, &block)
            else
              super
            end
          end
        end
        
        def method_missing(meth, *args, &block)
          scope = Erector::Widgets::Page.scope
          if scope.respond_to? meth
            scope.send(meth, *args, &block)
          else
            super
          end
        end
        
      RUBY
      
      #the views directory must already be added to the LOAD_PATH
      class_name = name().to_s().downcase().capitalize()
      #TODO also camelize?
      #Convention Assumption! I guess, requires the class to be named the same thing as the file
      file = "#{class_name.downcase()}.html.rb" 
      #TODO with ruby's require, we have to kill the vm and re-start to reload templates...
      # maybe just eval it? => not in scope
      # unless defined? class_name
      #   eval(@data)
      # end
      load file # so we need to define class methods that are available in the scope variable before we require it (to avoid NoMethodErrors), but that's impossible...
      klass = eval(class_name) # == constantize
      
      if block
        template = klass.new(locals) do 
          #TODO test this?
          text block.call() #if we're creating a layout here, and the passed in block just returns a string, don't think this will work...
        end
      else
        template = klass.new locals#, scope
        template.instance_eval <<-RUBY
          
        RUBY
      end
      
      pretty = options[:environment] == :development
      template.to_html(:prettyprint => pretty, :helpers => nil) #render it
    end

    #TODO
    def precompiled_template(locals)
      #data.to_str
    end
  end
  prefer ErectorTemplate, 'html.rb'
  prefer ErectorTemplate, 'rb'
  #erector is used as both the name of the engine and as the file extension...
  register 'erector', ErectorTemplate 
end

require 'tilt'

module Erector
  module Tilt
    Template = ::Tilt::ErectorTemplate
  end
end

#TODO: any calls to a tags should make sure that it starts with http://

#################################################
######### Sinatra => Erector helpers + locals
#################################################
#https://github.com/pivotal/erector/blob/master/lib/erector/rails2/extensions/rails_widget.rb

# class Erector::Widgets::Page
#   def initialize(locals)
#     super
#     
#   end
# end
