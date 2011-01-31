require File.expand_path( File.dirname( __FILE__ ) + "/../yui/css_compressor.rb" )
require "closure-compiler"

module Rapper
  # Compression methods for various types of assets.
  module Compressors
    
    # Use Richard Hulse's port of the YUI CSS Compressor to compress the
    # contents of a source file to a destination file.
    # 
    # @param [String] source Path to source CSS file.
    # 
    # @param [String] destination Path to destination CSS file.
    #   written to.
    def compress_css( source, destination )
      source = readable_file( source )
      destination = writable_file( source )
      
      destination.write( YUI::CSS.compress( source.read ) )
      destination.write "\n"
      
      source.close && destination.close
    end
    
    # Use Google's Closure Compiler to compress the JavaScript from a source
    # file to a destination file.
    # 
    # @param [String] source Path to source JavaScript file.
    # 
    # @param [String] destination Path to destination JavaScript file.
    def compress_js( source, destination, opts={} )
      source = readable_file( source )
      destination = writable_file( source )
      closure = Closure::Compiler.new( opts )
      
      destination.write( closure.compile( destination ) )
      destination.write "\n"
      
      source.close && destination.close
    end
    
  end
end