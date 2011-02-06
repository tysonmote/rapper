require 'yaml'

Dir[File.expand_path( File.dirname( __FILE__ ) + "/rapper/*.rb" )].each do |file|
  require file
end

# No batteries included, and no strings attached /
# No holds barred, no time for move fakin' /
# Gots to get the loot so I can bring home the bacon
module Rapper
  
  # The main Rapper class. Handles, well, everything.
  class Engine
    
    include Rapper::Config
    include Rapper::Logging
    include Rapper::Utils
    include Rapper::Compressors
    include Rapper::Versioning
    
    # Load the configuration YAML file and set the current environment.
    # 
    # @param [String] config_path Path to the configuration YAML file.
    # 
    # @param [String,Symbol] environment The current environment. This must
    #   map to an environment configured in the Rapper configuration file.
    def initialize( config_path, environment )
      @environment = environment
      @config = {}
      @definitions = {}
      load_config( config_path )
      log :verbose, "Loaded rappper with #{environment} environment from #{config_path}"
    end
    
    # Package assets according to the loaded config and definitions. Defaults
    # to packaging all asset types.
    # 
    # @param [<String>] types Asset types to refresh versions for.
    def package( *types )
      types = types.empty? ? asset_types : types
      log :info, "Packaging #{types.join( ', ' )}"
      
      types.each do |type|
        definition = @definitions[type]
        source = File.expand_path( definition["source_root"] )
        destination = definition["destination_root"]
        suffix = definition["suffix"]
        
        definition["assets"].each do |asset|
          name = asset.keys.first
          spec = asset.values.first.first
          
          source_files = asset_component_paths( type, name )
          destination_file = asset_path( type, name )
          
          log :verbose, "Joining #{definition["assets"].count} files to #{name}"
          join_files( source_files, destination_file )
          
          if get_config( "compress" )
            log :verbose, "Compressing #{name}"
            compress( destination_file )
          end
        end
      end
      
      refresh_versions( *types )
      update_definitions( *types )
    end
    
  end
end
