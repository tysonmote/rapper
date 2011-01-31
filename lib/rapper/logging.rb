module Rapper
  # Basic logging support.
  module Logging
    
    protected
    
    # Outputs all arguments (joined with spaces) to:
    #   * <code>stdout</code> if "log" is set to "stdout" in the environment
    #     configuration.
    #   * the configured file if "log" is set to "file" in the environment
    #     configuration.
    # 
    # @param [<String>] args Strings to be logged.
    def log( *args )
      puts args.join( " " ) if get_config( "log" ) == "stdout"
    end
    
  end
end
