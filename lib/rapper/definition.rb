module Rapper
  # Basic definition abstraction to make working with the wacky YAML structure
  # easier.
  class Definition
    
    def initialize( path )
      @path = path
      @type = File.basename( path, ".yml" )
      @definition = YAML.load_file( @path )
    end
    
    # =======================
    # = Definition settings =
    # =======================
    
    # @return [String] The root for asset component files.
    def source_root
      first_key_value( "source_root", @definition ) || ""
    end
    
    # @return [String] The root for packaged asset files.
    def destination_root
      first_key_value( "destination_root", @definition ) || ""
    end
    
    # @return [String] The suffix of files used in this definition.
    def suffix
      first_key_value( "suffix", @definition )
    end
    
    # ==========
    # = Assets =
    # ==========
    
    # @return [Hash] Simplified structure representing all asset definitions.
    def assets
      assets = {}
      
      first_key_value( "assets", @definition ).each do |spec|
        assets[spec.keys.first] = spec.values.first.inject({}) do |memo, item|
          memo.merge( item )
        end
      end
      
      assets
    end
    
    # Update the version string for a specific asset.
    # 
    # @param [String] name Asset name.
    # 
    # @param [String] version New version string for the asset.
    def set_version( name, version )
      first_key_value( "assets", @definition ).each do |spec|
        next unless spec[name]
        spec[name].each do |setting|
          next unless setting["version"]
          setting["version"] = version
        end
      end
    end
    
    # ==========
    # = Saving =
    # ==========
    
    # Writes the in-memory definition out to disk.
    def update
      File.open( @path, "w" ) do |file|
        file.puts @definition.to_yaml
      end
    end
    
    # =========
    # = Paths =
    # =========
    
    # @param [String] name The asset's name.
    # 
    # @return [String] Path to the packaged asset file.
    def asset_path( name )
      file_name = "#{name}.#{self.suffix}"
      File.join( self.destination_root, file_name )
    end
    
    # @param [String] name Name of the asset.
    # 
    # @return [Array<String>] Ordered list of the files that comprise the given
    #   asset.
    def asset_component_paths( name )
      spec = self.assets[name]
      
      if spec.nil?
        raise Rapper::Errors::InvalidAssetName,
          "'#{name}' is not a valid #{@type} asset. Make sure it is defined in the definition file."
      end
      
      ( spec["files"] || [] ).map do |file|
        file_name = "#{file}.#{self.suffix}"
        File.join( self.source_root, file_name )
      end
    end
    
    private
    
    # @param [Object] key Key to search for.
    # 
    # @param [Array<Hash>] array Array of Hash object to search in.
    # 
    # @return [Object,nil] The first value found for the key or nil of nothing
    #   was found.
    def first_key_value( key, array )
      hash = array.find { |h| h.keys.include? key }
      hash ? hash[key] : nil
    end
  end
end
