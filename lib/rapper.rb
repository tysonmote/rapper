require 'yaml'

class Rapper
  class << self
    def setup( config_file, environment )
      @environment = environment
      load_config( config_file )
    end
    
    # Update version hashes for the given bundle types (defaults to all types).
    # This does not write the updated bundle definition files out.
    def refresh_versions( *types )
      types = types.empty? ? self.types : types
      log "Refreshing bundle versions for:", types.join( ", " )
      
      types.each do |type|
        @definitions[type].each do |set, spec|
          path = path_for( set, type, true ) ############### TODO
          version = version( path )
          log path, "=>", version
          spec["version"] = version
        end
      end
    end
    
    # TODO: needs better name
    def update_definitions( *types )
      types = types.empty? ? self.types : types
      
      types.each do |type|
        path = config_path( type ) ############### TODO
        log "Updating", path
        File.open( path, "w" ) do |file|
          file.puts @definitions[type].to_yaml
        end
      end
    end
    alias :update_definition :update_definitions
    
    private
    
    def env_config
      @config[@environment]
    end
    alias :c :env_config
    
    def load_config( config_file )
      @config = YAML.load_file( config_file )
      @definitions ||= {}
      Dir[File.join( c["definition_config_root"], "*.yml" )].each do |bundles_definition_file|
        type = File.basename( bundles_definition_file, ".yml" )
        @definitions[type] = YAML.load_file( bundles_definition_file )
      end
    end
    
    def types
      @definitions.keys
    end
    
    def version( file_path )
      Digest::MD5.file( path ).to_s[0,4]
    end
    
    def log( *args )
      puts args.join( " " ) if c["log"] == "stdout"
    end
  end
end
