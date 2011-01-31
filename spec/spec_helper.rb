$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'spec'
require 'rapper'
require 'fileutils'

Spec::Runner.configure do |config|
  
  # Setup and tear down tmp files.
  
  config.before :all do
    Dir::mkdir( "tmp" ) unless FileTest::directory?( "tmp" )
  end
  
  config.after :each do
    # Dir[ "tmp/*" ].each { |f| FileUtils.rm( f ) }
  end
end
