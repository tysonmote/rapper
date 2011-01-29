require 'digest/md5'

module Rapper
  # Asset versioning methods.
  module Versioning
    
    private
    
    # Refresh the version hashes for the given asset types. If no arguments are
    # passed, version hashes for all asset types will be updated.
    # 
    # @param [<String>] types Asset types to refresh versions for.
    def refresh_versions( *types )
      types = types.empty? ? asset_types : types
      log "Refreshing bundle versions for:", types.join( ", " )
      
      types.each do |type|
        @definitions[type].each do |name, spec|
          path = asset_path( type, name )
          version = version( path )
          log path, "=>", version
          spec["version"] = version
        end
      end
    end
    
    # @param [String] file_path The path to a file to generate a version for.
    # 
    # @return [String] A four-character MD5 hash of the contents of the file.
    def version( file_path )
      Digest::MD5.file( path ).to_s[0,4]
    end
    
  end
end
