require 'yaml'

Dir[File.expand_path( File.dirname( __FILE__ ) + "/rapper/*.rb" )].each do |file|
  require file
end

# No batteries included, and no strings attached /
# No holds barred, no time for move fakin' /
# Gots to get the loot so I can bring home the bacon
module Rapper
  
  # Pass all method calls to <code>Rapper::Engine</code> to allow a simple
  # API. E.g. <code>Rapper.do_something</code> rather than
  # <code>Rapper::Engine.do_something</code> If this really bothers you, feel
  # free to fork and start a rival tribe of savage warriors.
  def self.method_missing( name, *args )
    Rapper::Engine.send( name, *args )
  end
  
  # The main Rapper class. Handles, well, everything.
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
      
      # TODO: <code>package()</code>?
      def bundle( *types )
        # Bundle the assets according to the config and definitions.
      end
      
      # Watch the asset component files and rebuild the asset when they change.
      def watch( *types )
        # TODO: Callbacks? Forking? How do we do this?
      end
      
    end
  end
end
