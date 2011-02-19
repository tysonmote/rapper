require 'digest/md5'
require 'tempfile'

module Rapper
  # Asset versioning methods.
  module Versioning
    
    protected
    
    # Refresh the version hashes for the given asset types. If no arguments are
    # passed, version hashes for all asset types will be updated.
    # 
    # @param [<String>] types Asset types to refresh versions for.
    def refresh_versions( *types )
      types = types.empty? ? asset_types : types
      
      log :info, "Refreshing versions for #{types.join( ', ' )}"
      
      types.each do |type|
        @definitions[type].assets.each do |name, spec|
          version = version( type, name )
          @definitions[type].set_version( name, version )
        end
      end
    end
    
    # @param [String] type The bundle type.
    # 
    # @param [String] name The name of the bundle.
    # 
    # @return [String] A four-character version hash for the given asset.
    def version( type, name )
      source_files = @definitions[type].asset_component_paths( name )
      destination_file = Tempfile.new( 'rapper' )
      join_files( source_files, destination_file.path )
      version = Digest::MD5.file( destination_file.path ).to_s[0,4]
      destination_file.unlink
      version
    end
    
  end
end
