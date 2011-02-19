require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Rapper do
  describe "setup" do
    it "loads configuration and environment" do
      lambda do
        Rapper::Engine.new( "spec/fixtures/config/assets.yml", "test" )
      end.should_not raise_error
    end
    
    it "bombs out if given a bad configuration file" do
      lambda do
        Rapper::Engine.new( "spec/fixtures/config/fake.yml", "test" )
      end.should raise_error( Errno::ENOENT )
    end
    
    it "bombs out if given an invalid environment" do
      lambda do
        Rapper::Engine.new( "spec/fixtures/config/assets.yml", "error" )
      end.should raise_error( Rapper::Errors::InvalidEnvironment )
    end
    
    it "bombs out if no definition_root setting is provided" do
      lambda do
        Rapper::Engine.new( "spec/fixtures/config/assets.yml", "test_no_definition_root" )
      end.should raise_error( Rapper::Errors::NoDefinitionRoot )
    end
    
    it "uses the given environment's specific config" do
      rapper = Rapper::Engine.new( "spec/fixtures/config/assets.yml", "test" )
      rapper.environment.should == "test"
      # private
      rapper.send( :env_config )["bundle"].should be_true
      rapper.send( :env_config )["compress"].should be_true
      rapper.send( :env_config )["version"].should be_false
    end
    
    it "uses default config when environment config isn't set for the setting" do
      rapper = Rapper::Engine.new( "spec/fixtures/config/assets.yml", "test_empty" )
      # private
      rapper.send( :get_config, "bundle" ).should be_true
      rapper.send( :get_config, "compress" ).should be_true
      rapper.send( :get_config, "version" ).should be_true
      rapper.send( :get_config, "closure_compiler" ).should == {
        "compilation_level" => "SIMPLE_OPTIMIZATIONS"
      }
    end
    
    it "loads asset definitions" do
      rapper = Rapper::Engine.new( "spec/fixtures/config/assets.yml", "test" )
      rapper.send( :asset_types ).sort.should == ["javascripts", "stylesheets"]
      rapper.definitions["javascripts"].should be_a( Rapper::Definition )
      rapper.definitions["stylesheets"].should be_a( Rapper::Definition )
      rapper.definitions["javascripts"].source_root.should == "spec/fixtures/javascripts"
      rapper.definitions["javascripts"].destination_root.should == "tmp"
      rapper.definitions["javascripts"].suffix.should == "js"
      rapper.definitions["javascripts"].assets.should == {
        "single_file"=>{
          "files"=>["simple_1"],
          "version"=>0
        },
        "multiple_files"=>{
          "files"=>["simple_1", "simple_2"],
          "version"=>0
        }
      }
    end
  end
  
  describe "logging" do
    it "is off by default" do
      lambda do
        Rapper::Engine.new( "spec/fixtures/config/assets.yml", "test_empty" )
      end.should_not have_stdout( /./ )
    end
    
    it "can log to stdout" do
      lambda do
        rapper = Rapper::Engine.new( "spec/fixtures/config/assets.yml", "test_logging_stdout" )
        rapper.send( :log, :info, "Derp" )
      end.should have_stdout( "Derp" )
    end
    
    it "doesn't log verbose messages unless configured" do
      lambda do
        rapper = Rapper::Engine.new( "spec/fixtures/config/assets.yml", "test_logging_stdout" )
        rapper.send( :log, :verbose, "Derp" )
      end.should_not have_stdout( "Derp" )
    end
    
    it "logs verbose messages if configured" do
      lambda do
        rapper = Rapper::Engine.new( "spec/fixtures/config/assets.yml", "test_logging_verbose" )
        rapper.send( :log, :verbose, "Derp" )
      end.should have_stdout( "Derp" )
    end
    
    it "can log to a file" do
      rapper = Rapper::Engine.new( "spec/fixtures/config/assets.yml", "test_logging_file" )
      rapper.send( :log, :info, "Derp" )
      File.read( "tmp/test_logging_file.log" ).should == "Derp\n"
    end
  end
  
  describe "versioning" do
    it "uses the concatenated file to calculate versions" do
      rapper = Rapper::Engine.new( "spec/fixtures/config/assets.yml", "test" )
      rapper.send( :refresh_versions )
      rapper.definitions["javascripts"].assets["single_file"].should == {
        "files"=>["simple_1"],
        "version"=>"98bc"
      }
      rapper.definitions["javascripts"].assets["multiple_files"].should == {
        "files"=>["simple_1", "simple_2"],
        "version"=>"f3d9"
      }
    end
    
    it "doesn't re-package assets that don't need re-packaging" do
      rapper = Rapper::Engine.new( "spec/fixtures/config/assets.yml", "test" )
      rapper.stub!( :update_definitions ).and_return( nil ) # Block definition updating
      rapper.package
      
      rapper.should_not_receive( :compress )
      rapper.package
    end
  end
  
  describe "packaging test cases" do
    Dir["spec/fixtures/test_cases/*"].each do |folder|
      next unless File.directory?( folder )
      name = folder.split( "/" ).last
      results_path = "tmp/*.*"
      expecteds_path = "#{folder}/expected/*.*"
      
      it "passes the \"#{name}\" test case" do
        rapper = Rapper::Engine.new( "#{folder}/assets.yml", "test" )
        rapper.package
        
        # Produces the same exact individual files
        file_names( results_path ).should == file_names( expecteds_path )
        # Contents are all the same
        results = Dir[results_path]
        expecteds = Dir[expecteds_path]
        
        results.each_index do |i|
          unless File.read( results[i] ) == File.read( expecteds[i] )
            raise "#{results[i]} did not match #{expecteds[i]}"
          end
        end
      end
    end
  end
  
  describe "bundling" do
    it "raises an error if a file doesn't exist"
  end
  
  describe "view helpers" do
    it "returns tags for component files when bundling is off"
    it "returns tabs for asset when bundling is on"
    it "can return html"
    it "can return xhtml"
    it "can return html5"
    it "adds a version number if versioning is on"
    it "doesn't add a version number if versioning is off"
  end
end
