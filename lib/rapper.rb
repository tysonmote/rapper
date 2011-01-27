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
          path = path_for( set, type, true ) ###############
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
        path = config_path( type ) #################
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


class OldBundler
  
  def initialize( config_root, opts={} )
    @config_root = config_root.sub( /\//, "" )
    @bundles = {}
    Dir["#{config_root}/*.yml"].each do |path|
      type = path.scan( /([^\/]+)\.yml/ ).first.first
      @bundles[type] = YAML.load_file( path )
    end
    @opts = opts
  end
  
  # Rebundle all bundles for the given types (or all types of bundles if none
  # are passed in). This involves created a concatenated file of all the
  # component files and then passing it through YUICompressor. YUICompressor is
  # a Java jar and it, unfortunately, is slow as shit.
  def bundle( *types )
    types = types.empty? ? @bundles.keys : types
    types.each do |type|
      log "Bundling", type
      extension = extensions[type]
      folder = folders[type]
      
      @bundles[type].each do |set, spec|
        log "Updating", "#{set}.#{extension}", "bundle"
        bundle_path = path_for( set, type, true )
        
        # Concatenate component files
        File.open( bundle_path, "w" ) do |bundle|
          spec["files"].each do |component|
            component_path = path_for( component, type )
            Dir[component_path].each do |component_file|
              bundle.puts( File.read( component_file ) )
            end
          end
        end
        
        # Compress
        `java -jar vendor/yuicompressor-2.4.2.jar -o #{bundle_path} #{bundle_path}`
      end
    end
  end
  
  # Update version hashes for the given bundle types (defaults to all types).
  # This does not write the updated config files out.
  # def refresh_versions( *types )
  #   types = types.empty? ? @bundles.keys : types
  #   log "Refreshing bundles for:", types.join( ", " )
  #   types.each do |type|
  #     @bundles[type].each do |set, spec|
  #       path = path_for( set, type, true )
  #       version = version_for( path )
  #       log path, "=>", version
  #       spec["version"] = version
  #     end
  #   end
  # end
  
  # Write the config YAML files out.
  # def update_config( *types )
  #   types = types.empty? ? @bundles.keys : types
  #   types.each do |type|
  #     path = config_path( type )
  #     log "Updating", path
  #     File.open( path, "w" ) do |file|
  #       file.puts @bundles[type].to_yaml
  #     end
  #   end
  # end
  # alias :update_configs :update_config
  
  protected
  
  # Log to stdout if @opts[:log] is truthy.
  def log( *args )
    puts args.join( " " ) if @opts[:log]
  end
  
  # Map of bundle types to file extensions.
  def extensions
    {
      "stylesheets" => "css",
      "javascripts" => "js",
      "cml_validators" => "js"
    }
  end
  
  # Map of bundle types to bundle folder destinations.
  def folders
    {
      "stylesheets" => "stylesheets",
      "javascripts" => "javascripts",
      "cml_validators" => "javascripts"
    }
  end
  
  # The config YAML file path for the given bundle type.
  def config_path( type )
    "config/bundles/#{type}.yml"
  end
  
  # Computes a 4-character version "number" for the given file.
  def version_for( path )
    Digest::MD5.file( path ).to_s[0,4]
  end
  
  def path_for( name, type, bundle = false )
    extension = extensions[type]
    folder = folders[type]
    
    # Ensure we have the needed directories
    if bundle
      parts = name.split( "/" )
      parts.pop
      dir = "public/#{folder}/bundles/#{parts.join("/")}"
      mkdir_p dir unless File.exists?( dir )
    end
    
    "public/#{folder}#{"/bundles" if bundle}/#{name}.#{extension}"
  end
  
end
