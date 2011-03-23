module Rapper
  
  # Rake tasks for building / refreshing packages
  class Tasks
    
    def initialize( namespace = :rapper, &block )
      @namespace = namespace
      @config = {}
      yield @config
      @config[:env] ||= :production
      @rapper = Rapper::Engine.new( @config[:path], @config[:env] )
      define
    end
    
    private
    
    def define
      namespace @namespace do
        desc "Package all assets that need re-packaging"
        task :package do
          @rapper.package
        end
        
        namespace :package do
          @rapper.definitions.each do |type, definition|
            desc "Package all #{type} assets that need re-packaging"
            task key do
              @rapper.package( type )
            end
          end
        end
      end
    end
  end
end
