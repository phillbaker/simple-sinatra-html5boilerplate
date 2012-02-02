module Erector
  module Widgets
    #html5-boilerplate v2.0 based on:
    #https://github.com/paulirish/html5-boilerplate/blob/v2.0/index.html
    # Place favicon.ico and apple-touch-icon.png in the root directory: mathiasbynens.be/notes/touch-icons
    #
    # TODO: erector is xhtml based, meta and link tags don't need to be self closing in html5 doctype
    class Html5boilerplate < Page
      # def initialize(assigns = {}, scope = nil, &block)
      #   super(assigns, &block)
      #   @@scope = scope
      #   puts "there"
      #   puts @@scope
      # end
      # 
      # class<<self
      #   attr_accessor :scope
      #   def method_missing(meth, *args, &block)
      #     #Sinatra::AssetPack.css
      #     #if asset_pack.respond_to?(meth)
      #     # asset_pack.send(meth, *args, & block)
      #     # else super(meth)
      #     # if meth.to_s =~ /^get_css_url$/
      #     #   "hello"
      #     # else
      #     #   super
      #     # end
      #     puts "here"
      #     puts @scope
      #     #puts @@scope
      #     #@scope.send(meth, *args, &block)
      #   end
      # end
      #CSS: implied media=all #TODO still printed: media="all" type="text/css"
      #can be concatenated and minified via build scripts/etc.
      #external :css, 'css/style.css'
      css_urls(:application).each do |url|
        external(:css, url)
      end
      # [1,2].each do |url|
      #   external :css, "css/style#{url}.css"
      # end
      #Sinatra::AssetPack
      
      #All JavaScript at the bottom, except for Modernizr / Respond.
      #Modernizr enables HTML5 elements & feature detects; Respond is a polyfill for min/max-width CSS3 Media Queries
      #For optimal performance, use a custom Modernizr build: www.modernizr.com/download/
      external :js, 'js/libs/modernizr-2.0.6.min.js' #TODO still printed: type="text/javascript"
      
      def doctype
        "<!doctype html>"
      end
      
      # Create a named haml tag to wrap IE conditional around a block
      # http://paulirish.com/2008/conditional-stylesheets-vs-css-hacks-answer-neither
      def html_ie_conditional(html_attributes = {})
        # <!--[if lt IE 7]> <html class="no-js ie6 oldie" lang="en"> <![endif]-->
        # <!--[if IE 7]> <html class="no-js ie7 oldie" lang="en"> <![endif]-->
        # <!--[if IE 8]> <html class="no-js ie8 oldie" lang="en"> <![endif]-->
        # <!--[if gt IE 8]><!--> <html class="no-js" lang="en"> <!--<![endif]-->
        comment('[if lt IE 7 ]') do
          attrs = html_attributes()
          attrs[:class] << :ie6
          open_tag(:html, attrs)
        end
        comment('[if IE 7 ]') do
          attrs = html_attributes()
          attrs[:class] << :ie7
          open_tag(:html, attrs)
        end
        comment('[if IE 8 ]') do
          attrs = html_attributes()
          attrs[:class] << :ie8
          open_tag(:html, attrs)
        end
        comment('[if gt IE 8]') do
          rawtext('<!-->')
          open_tag(:html, html_attributes())
          rawtext('<!--')
        end
        yield if block_given?
        close_tag('html')
      end
      #replace default html, basically alias_method_chain
      alias_method :html_default, :html 
      alias_method :html, :html_ie_conditional

      
      def html_attributes
        { :class => [:'no-js'], :lang => :en }
      end

      def head_content
        meta(:charset => 'utf-8')

        #Use the .htaccess and remove these lines to avoid edge case issues. More info: h5bp.com/b/378
        meta(:'http-equiv' => 'X-UA-Compatible', :content => 'IE=edge,chrome=1')
        
        meta(:name => :description, :content => (description() || ''))
        meta(:name => :author, :content => (author() || ''))

        #Mobile viewport optimized: j.mp/bplateviewport
        meta(:name => :viewport, :content => 'width=device-width,initial-scale=1')
        
        #More ideas for your <head> here: h5bp.com/d/head-Tips
        
        title page_title
      end
      
      #Over ride me to provide head description or call with block
      def description
        yield if block_given?
      end
      
      #Over ride me to provide author description or call with block
      def author
        yield if block_given?
      end
      
      #Body, with initial structure, override sub-parts to provide content
      def body_content
        div(:id => :container) do
          header do
            header_content()
          end
          div(:id => :main, :role => :main) do
            main_content()
          end
          footer do
            footer_content()
          end
        end
        #JavaScript at the bottom for fast page loading
        scripts()
      end #end of body_content
      
      #Over ride me to provide header content or call with block
      def header_content
        yield if block_given?
      end

      #Over ride me to provide main content or call with block
      def main_content
        yield if block_given?
      end
      
      #Over ride me to provide footer content or call with block
      def footer_content
        yield if block_given?
      end
      
      #call with block to add additional scripts from plugins
      def scripts
        #Grab Google CDN's jQuery, with a protocol relative URL; fall back to local if offline
        script(:src => '//ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.min.js')
        script do
          rawtext(%{window.jQuery || document.write('<script src="js/libs/jquery-1.6.2.min.js"><\\/script>')})
        end
        #can be minified/concatenated
        script(:defer => 'defer', :src => 'js/plugins.js') #TODO should just be "defer" without attribute, but erector doesn't really do that
        script(:defer => 'defer', :src => 'js/script.js')
        
        #removed google analytics tag
        
        #Prompt IE 6 users to install Chrome Frame. Remove this if you want to support IE 6. 
        # chromium.org/developers/how-tos/chrome-frame-getting-started
        comment('[if IE 7 ]') do
          script(:src => '//ajax.googleapis.com/ajax/libs/chrome-frame/1.0.3/CFInstall.min.js')
          script do
            rawtext(%{window.attachEvent('onload',function(){CFInstall.check({mode:'overlay'})})})
          end
        end
        
        yield if block_given?
      end#scripts
      
    end
  end
end
