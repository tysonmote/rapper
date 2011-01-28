require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Rapper do
  describe "setup" do
    it "loads configuration and environment" do
      Rapper.setup( "spec/fixtures/config/assets.yml", "development" )
    end
    
    it "bombs out if given a bad configuration file" do
      lambda { Rapper.configure( "config/assets.yml", "development" ) }.should raise_error
    end
    
    it "uses the given environment's specific config" do
      Rapper.setup( "spec/fixtures/config/assets.yml", "development" )
    end
  end
  
  describe "bundling" do
    it "concatenates files"
    it "compresses, if configured to"
  end
end
