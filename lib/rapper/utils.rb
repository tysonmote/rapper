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
      
      file_name = "#{name}.#{@definitions[type]["suffix"]}"
      
      File.join( @definitions[type]["destination_root"], file_name )
    end
    
    def asset_component_paths( type, name )
      if @definitions[type].nil?
        raise Rapper::Errors::InvalidDefinitionType,
          "'#{type}' is not a defined asset type."
      end
      
      spec = first_hash_with_key( name, @definitions[type]["assets"] )
      
      if spec.nil?
        raise Rapper::Errors::InvalidAssetName,
          "'#{name}' is not a valid #{type} asset. Make sure it is defined in the definition file."
      end
      
      source_root = @definitions[type]["source_root"]
      suffix = @definitions[type]["suffix"]
      
      files = first_hash_with_key( "files", spec.values.first )["files"] || []
      
      files.map do |file|
        file_name = "#{file}.#{suffix}"
        File.join( source_root, file_name )
      end
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
    
    def first_hash_with_key( value, array )
      array.find { |h| h.keys.include? value }
    end
    
  end
end
