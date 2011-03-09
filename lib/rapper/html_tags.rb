require 'erb'

module Rapper
  module HtmlTags
    
    def tag_method_for_type( type )
      if @definitions[type].suffix =~ /css/
        :css_tag
      else
        :js_tag
      end
    end
    
    def js_tag( type, name )
      self.get_tag( JsTag, type, name )
    end
    
    def css_tag( type, name )
      self.get_tag( CssTag, type, name )
    end
    
    protected
    
    def get_tag( klass, type, name )
      definition = @definitions[type]
      style = self.get_config( 'tag_style' ).to_sym
      version = nil
      if self.get_config( 'version' )
        version = definition.get_version( name )
      end
      
      if self.get_config( "bundle" )
        path = definition.asset_path( name, definition.asset_tag_root )
        klass.send( :for, path, version, style )
      else
        paths = definition.component_paths( name, definition.component_tag_root )
        paths.map do |path|
          klass.send( :for, path, version, style )
        end.join( "\n" )
      end
    end
    
    class Tag
      class << self
        def templates
          {}
        end
        
        def for( path, version, style )
          @cache ||= {}
          @cache[style] ||= {}
          
          if version
            path << "?v=#{version}"
          end
          
          unless @cache[style][path] && @cache[style][path]
            @cache[style][path] = ERB.new( templates[style] ).result( binding )
          end
          
          @cache[style][path]
        end
      end
    end
    
    class JsTag < Tag
      class << self
        def templates
          {
            :html => '<script type="text/javascript" src="<%= path %>"></script>',
            :html5 => "<script src=\"<%= path %>\"></script>",
            :xhtml => '<script type="text/javascript" src="<%= path %>"></script>'
          }
        end
      end
    end
    
    class CssTag < Tag
      class << self
        def templates
          {
            :html => '<link type="text/css" rel="stylesheet" href="<%= path %>">',
            :html5 => "<link rel=\"stylesheet\" href=\"<%= path %>\">",
            :xhtml => '<link type="text/css" rel="stylesheet" href="<%= path %>" />'
          }
        end
      end
    end
  end
end
