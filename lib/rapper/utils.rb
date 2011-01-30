module Rapper
  # Rapper-wide utility methods.
  module Utils
    
    protected
    
    # Given an asset type and asset name, return a path to that asset, locally.
    def asset_path( type, name )
      if @definitions[type].nil?
        raise Rapper::Errors::InvalidDefinitionType,
          "'#{type}' is not a defined asset type."
      end
      
      [
        @definitions[type]["source_root"],
        "#{name}.#{@definitions[type]["suffix"]}"
      ].join( "/" )
    end
    
    # Contatenate one or more files. Uses <code>cat</code>.
    # 
    # @param [Array<String>,String] source_files A  path or array of paths to
    #   files to concatenate.
    # 
    # @param [String] destination_file Destination for concatenated output.
    def join_files( source_files, destination_file )
      source_files = Array( source_files ).uniq.join( " " )
      system "cat #{source_files} > #{destination_file}"
    end
    
  end
end
