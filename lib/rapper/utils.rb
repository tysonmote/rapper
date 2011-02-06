module Rapper
  # Rapper-wide utility methods for working with paths, files, etc.
  module Utils
    
    protected
    
    # =========
    # = Paths =
    # =========
    
    # @param [String] type Asset type.
    # 
    # @return [String] Path to the definition file for the given asset type.
    def definition_path( type )
      File.join( get_config( "definition_root" ), "#{type}.yml")
    end
    
    # @param [String] type Asset type.
    # 
    # @param [String] name Name of the asset.
    # 
    # @return [String] Path to the packaged asset file for the given type and
    #   name.
    def asset_path( type, name )
      if @definitions[type].nil?
        raise Rapper::Errors::InvalidDefinitionType,
          "'#{type}' is not a defined asset type."
      end
      
      file_name = "#{name}.#{@definitions[type]["suffix"]}"
      
      File.join( @definitions[type]["destination_root"], file_name )
    end
    
    # @param [String] type Asset type.
    # 
    # @param [String] name Name of the asset.
    # 
    # @return [Array<String>] Ordered list of asset component file paths.
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
    
    # =========
    # = Files =
    # =========
    
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
    
    # =========
    # = Misc. =
    # =========
    
    # @param [Object] key Key to search for.
    # 
    # @param [Array<Hash>] array Array of Hash object to search in.
    # 
    # @return [Hash] First hash with the given key.
    def first_hash_with_key( key, array )
      array.find { |h| h.keys.include? key }
    end
    
  end
end
