require 'yaml'

module Rapper
  # Rapper configuration and definition methods.
  module Config
    
    attr_accessor :environment, :config, :definitions
    
    protected
    
    # Load the Rapper configuration from a YAML file and all asset definition
    # YAML files in the folder specified in the current environment's
    # <code>definition_root</code> setting. The definition type is inferred
    # from the file name. E.g. The type key for <code>javascript.yml</code>
    # will be "javascript".
    # 
    # @param [String] config_path The path to the configuration YAML file.
    def load_config( config_path )
      @config = YAML.load_file( config_path )
      @definitions = {}
      if env_config.nil?
        raise Rapper::Errors::InvalidEnvironment,
          "The '#{@environment}' environment is not defined in #{config_path}"
      end
      definition_path = File.join( env_config["definition_root"], "*.yml" )
      Dir[definition_path].each do |definition|
        type = File.basename( definition, ".yml" )
        @definitions[type] = YAML.load_file( definition )
      end
    end
    
    private
    
    # Update the asset definition files. (Typically done to after regenerating
    # versions.)
    # 
    # @param [<String>] types Asset types to update the definition files for.
    def update_asset_definitions( *types )
      types = types.empty? ? asset_types : types
      
      types.each do |type|
        log "Updating definition file for", type
        File.open( path, "w" ) do |file|
          file.puts @definitions[type].to_yaml
        end
      end
    end
    
    # @return [Hash] The configuration for the currently set environment.
    def env_config
      @config[@environment]
    end
    
    # @return [Array<String>] All defined asset types.
    def asset_types
      @definitions.keys
    end
    
  end
end
