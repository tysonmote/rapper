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
    
    protected
    
    # Get the config setting for the given key.
    # 
    # @param [String] key Configuration key.
    # 
    # @return [String,Hash] If the current environment's config defines this
    #   setting, return that value. If not, return the default setting. If the
    #   default setting is a hash, return the default merged with the
    #   environment's setting.
    def get_config( key )
      if default_config[key].is_a?( Hash )
        default_config[key].merge( env_config[key] || {} )
      else
        env_config[key] || default_config[key]
      end
    end
    
    # Update the asset definition files. (Typically done after regenerating
    # versions.)
    # 
    # @param [<String>] types Asset types to update the definition files for.
    #   Defaults to all types.
    def update_definitions( *types )
      types = types.empty? ? asset_types : types
      
      types.each do |type|
        log "Updating definition file for", type
        File.open( definition_path( type ), "w" ) do |file|
          file.puts @definitions[type].to_yaml
        end
      end
    end
    
    private
    
    # @return [Hash] Default rapper configuration.
    def default_config
      {
        "definition_root" => ".",
        "bundle" => true,
        "compress" => true,
        "tag_style" => "html5",
        "versions" => true,
        "closure_compiler" => {
          "compilation_level" => "SIMPLE_OPTIMIZATIONS"
        }
      }
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
