require 'yaml'

Dir[File.expand_path( File.dirname( __FILE__ ) + "/rapper/*.rb" )].each do |file|
  require file
end

module Rapper
  
  # Pass all method calls to <code>Rapper::Engine</code>
  def self.method_missing( name, *args )
    Rapper::Engine.send( name, *args )
  end
  
  class Engine
    class << self
      
      include Rapper::Config
      include Rapper::Logging
      include Rapper::Utils
      include Rapper::Versioning
      
      # Load the configuration YAML file and set the current environment.
      # 
      # @param [String] config_path Path to the configuration YAML file.
      # 
      # @param [String,Symbol] environment The current environment. This must
      #   map to an environment configured in the Rapper configuration file.
      def setup( config_path, environment )
        @environment = environment
        load_config( config_path )
      end
      
    end
  end
end
