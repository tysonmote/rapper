module Rapper
  # Common Rapper errors.
  module Errors
    
    # Raised when an invalid environment param is used. An invalid environment
    # is one not defined in the current rapper config.
    class InvalidEnvironment < StandardError; end
    
    # Raised when an invalid definition type param is used. An invalid
    # definition type is one that doesn't have a definition YAML file in the
    # "definition_root" folder (set in the config).
    class InvalidDefinitionType < StandardError; end
    
    # Raised when an invalid asset name param is used. An invalid asset name
    # is one not defined in a given definition file.
    class InvalidAssetName < StandardError; end
    
  end
end
