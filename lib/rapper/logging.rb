module Rapper
  module Logging
    
    private
    
    # Outputs all arguments (joined with spaces) to <code>stdout</code> if
    # "log" is set to "stdout" in the environment configuration.
    # 
    # @param [<String>] args Strings to be output.
    def log( *args )
      puts args.join( " " ) if env_config["log"] == "stdout"
    end
    
  end
end
