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
      @definition["root"]
    end
    
    def destination_root
      @definition["root"].gsub( /\/$/, '' ) + "/assets"
    end
    
    # @return [String] The public url root for the asset component files (used
    # when bundling is off).
    def component_tag_root
      @definition["tag_root"]
    end
    
    # @return [String] The public url root for packaged asset files.
    def asset_tag_root
      @definition["tag_root"].gsub( /\/$/, '' ) + "/assets"
    end
    
    # @return [String] The suffix of files used in this definition.
    def suffix
      @definition["suffix"]
    end
    
    # ==========
    # = Assets =
    # ==========
    
    def assets
      @definition["assets"]
    end
    
    # Update the version string for a specific asset.
    # 
    # @param [String] name Asset name.
    # 
    # @param [String] version New version string for the asset.
    def set_version( name, version )
      @definition["assets"][name.to_s]["version"] = version
    end 
    
    def get_version( name )
      @definition["assets"][name.to_s]["version"]
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
  end
end
