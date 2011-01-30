require File.expand_path( File.dirname( __FILE__ ) + "/../yui/css_compressor.rb" )

module Rapper
  module Compressors
    
    # Use Richard Hulse's port of the YUI CSS Compressor to compress the given
    # CSS string.
    # 
    # @param [String] css CSS to be compressed.
    # 
    # @return [String] Compressed CSS.
    def compress_css( css )
      YUI::CSSCompressor.compress( css )
    end
    
  end
end