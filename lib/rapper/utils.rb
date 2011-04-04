module Rapper
  # Rapper-wide utility methods for working with paths, files, etc.
  module Utils
    
    protected
    
    # =========
    # = Files =
    # =========
    
    # Concatenate one or more files. Uses <code>cat</code>.
    # 
    # @param [Array<String>,String] source_files A  path or array of paths to
    # files to concatenate.
    # 
    # @param [String] destination_file Destination for concatenated output.
    def join_files( source_files, destination_file )
      source_files = Array( source_files ).uniq
      raise Rapper::Errors::MissingComponentFile if source_files.any? do |f|
        !File.exists?( f )
      end
      system "cat #{source_files.join( " " )} > #{destination_file}"
    end
    
  end
end
