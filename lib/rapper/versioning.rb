require 'digest/md5'

module Rapper
  module Versioning
    
    # Refresh the version hashes for the given asset types. If no arguments are
    # passed, version hashes for all asset types will be updated.
    # 
    # @param [<String>] types Asset types to refresh versions for.
    def refresh_versions( *types )
      types = types.empty? ? asset_types : types
      log "Refreshing bundle versions for:", types.join( ", " )
      
      types.each do |type|
        @definitions[type].each do |set, spec|
          path = path_for( set, type, true ) ############### TODO
          version = version( path )
          log path, "=>", version
          spec["version"] = version
        end
      end
    end
    
    private
    
    # @param [String] file_path The path to a file to generate a version for.
    # 
    # @return [String] A four-character MD5 hash of the contents of the file.
    def version( file_path )
      Digest::MD5.file( path ).to_s[0,4]
    end
    
  end
end
