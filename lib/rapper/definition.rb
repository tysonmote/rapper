module Rapper
  # Basic definition abstraction to make working with the wacky YAML structure
  # easier.
  class Definition
    
    def initialize( path )
      @path = path
      @type = File.basename( path, ".yml" )
      @definition = YAML.load_file( @path )
      # Create asset destination folder, if needed
      Dir.mkdir( destination_root ) unless File.directory?( destination_root )
    end
    
    # =======================
    # = Definition settings =
    # =======================
    
    # @return [String] The root for asset component files.
    def root
      definition_value( "root" )
    end
    
    def destination_root
      definition_value( "root" ).gsub( /\/$/, '' ) + "/assets"
    end
    
    # @return [String] The public url root for the asset component files (used
    # when bundling is off).
    def component_tag_root
      definition_value( "tag_root" )
    end
    
    # @return [String] The public url root for packaged asset files.
    def asset_tag_root
      definition_value( "tag_root" ).gsub( /\/$/, '' ) + "/assets"
    end
    
    # @return [String] The suffix of files used in this definition.
    def suffix
      definition_value( "suffix" )
    end
    
    # ==========
    # = Assets =
    # ==========
    
    # @return [Hash] Simplified structure representing all asset definitions.
    def assets
      assets = {}
      
      definition_value( "assets" ).each do |spec|
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
      name = name.to_s
      definition_value( "assets" ).each do |spec|
        next unless spec[name]
        spec[name].each do |setting|
          next unless setting["version"]
          setting["version"] = version
        end
      end
    end 
    
    def get_version( name )
      name = name.to_s
      definition_value( "assets" ).each do |spec|
        next unless spec[name]
        spec[name].each do |setting|
          next unless setting["version"]
          return setting["version"]
        end
      end
      
      false
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
    def asset_path( name, root=nil )
      root ||= self.destination_root
      file_name = "#{name}.#{self.suffix}"
      File.join( root, file_name )
    end
    
    # @param [String] name Name of the asset.
    # 
    # @return [Array<String>] Ordered list of the files that comprise the given
    #   asset.
    def component_paths( name, root=nil )
      root ||= self.root
      spec = self.assets[name.to_s]
      
      if spec.nil?
        raise Rapper::Errors::InvalidAssetName,
          "'#{name}' is not a valid #{@type} asset. Make sure it is defined in the definition file."
      end
      
      ( spec["files"] || [] ).map do |file|
        file_name = "#{file}.#{self.suffix}"
        File.join( root, file_name )
      end
    end
    
    private
    
    # @param [Object] key Key to search for.
    # 
    # @param [Array<Hash>] array Array of Hash object to search in.
    # 
    # @return [Object,nil] The first value found for the key or nil of nothing
    #   was found.
    def definition_value( key )
      hash = @definition.find { |h| h.keys.include? key }
      hash ? hash[key] : ""
    end
  end
end
