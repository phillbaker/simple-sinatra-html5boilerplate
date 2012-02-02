require 'sinatra/assetpack'

module Sinatra
  module AssetPack
    module Helpers
      def css_urls *names
        package_urls :css, *names
      end
    
      def js_urls *names
        package_urls :js, *names
      end
    
      def package_urls type, *args
        names = Array.new
        while args.first.is_a?(Symbol)
          names << args.shift
        end
        
        urls = names.map do |name|
          package_url type, name
        end
        urls.flatten
      end
    
      def package_url type, name
        pack = settings.assets.packages["#{name}.#{type}"]
        return "" unless pack

        ret = []
        if settings.production?
          ret << pack.production_path
        else
          ret = pack.paths_and_files.map do |path, file|
            pack.add_cache_buster(path, file)
          end
        end
        ret
      end
    end
  end
end