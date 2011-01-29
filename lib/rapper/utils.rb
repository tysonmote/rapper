module Rapper
  # Rapper-wide utility methods.
  module Utils
    
    private
    
    # Given an asset type and asset name, return a path to that asset, locally.
    def asset_path( type, name )
      if @definitions[type].nil?
        raise Rapper::Errors::InvalidDefinitionType,
          "'#{type}' is not a defined asset type."
      end
      
      [
        @definitions[type]["source_root"],
        "#{name}.#{@definitions[type]["suffix"]}"
      ].join( "/" )
    end
    
  end
end
