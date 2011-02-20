module Rapper
  # Set up view helpers for various web frameworks. Currently supported:
  #   * Merb
  # To do:
  #   * Sinatra
  module HelperSetup
    
    # Loads view helpers for any/all available web frameworks available.
    # TODO: Refactor.
    def setup_helpers
      if Rapper::ViewHelpers.const_defined?( :RAPPER )
        Rapper::ViewHelpers.send( :remove_const, :RAPPER )
      end
      Rapper::ViewHelpers.const_set( :RAPPER, self )
      
      # Merb
      begin
        Merb::Controller.send( :include, Rapper::ViewHelpers )
      rescue NameError; end
    end
    
    private
  end
  
  module ViewHelpers
    
    RAPPER = nil
    
    def self.included( klass )
      klass.class_eval do
        # Define a "rapper_FOO_tag" method for each definition type. For
        # example, if you have "stylesheets" and "javascripts" definitions,
        # you'll have "rapper_stylesheets_tag( name )" and
        # "rapper_javascripts_tag( name )" methods.
        RAPPER.definitions.each do |type, definition|
          tag_method = RAPPER.tag_method_for_type( type )
          define_method "rapper_#{type}_tag".to_sym do |name|
            RAPPER.send( tag_method, type, name )
          end
        end
      end
    end
  end
  
end
