module Rapper
  # Common Rapper errors.
  module Errors
    
    # Raised when an invalid environment param is used.
    class InvalidEnvironment < StandardError; end
    
    # Raised when an invalid definition type param is used.
    class InvalidDefinitionType < StandardError; end
    
    # Raised when an invalid Asset name param is used.
    class InvalidAssetName < StandardError; end
    
  end
end
