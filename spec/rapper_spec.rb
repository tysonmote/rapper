require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Closure::Compiler do
  it "shoud be available" do
    closure = Closure::Compiler.new
    closure.compile( "var x = 1; var y = 2;" ).should == "var x=1,y=2;\n"
  end
    
    it "provides whitespace-only, simple, and advanced compression" do
      # https://github.com/documentcloud/closure-compiler/blob/master/test/unit/test_closure_compiler.rb
      
      original = "window.hello = function(name) { return console.log('hello ' + name ); }; hello.squared = function(num) { return num * num; }; hello('world');"
      compiled_whitespace = "window.hello=function(name){return console.log(\"hello \"+name)};hello.squared=function(num){return num*num};hello(\"world\");\n"
      compiled_simple = "window.hello=function(a){return console.log(\"hello \"+a)};hello.squared=function(a){return a*a};hello(\"world\");\n"
      compiled_advanced = "window.a=function(b){return console.log(\"hello \"+b)};hello.b=function(b){return b*b};hello(\"world\");\n"
      
      Closure::Compiler.new( :compilation_level => "WHITESPACE_ONLY" ).compile(original).should == compiled_whitespace
      Closure::Compiler.new.compile(original).should == compiled_simple
      Closure::Compiler.new( :compilation_level => "ADVANCED_OPTIMIZATIONS" ).compile(original).should == compiled_advanced
    end
end

describe YUI::CSS do
  # https://github.com/rhulse/ruby-css-toolkit/blob/master/test/yui_compressor_test.rb
  
  test_files = Dir[File.join( File.dirname( __FILE__ ), '/fixtures/yui_css/*.css' )]
  test_files.each_with_index do |file, i|
    test_css = File.read(file)
    expected_css = File.read( file + '.min' )
    test_name = File.basename( file, ".css" )
    
    it "passes the \"#{test_name}\" test case" do
      YUI::CSS.compress( test_css ).should == expected_css
    end
  end
end

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
      rapper.send( :get_config, "versions" ).should be_true
      rapper.send( :get_config, "closure_compiler" ).should == {
        "compilation_level" => "SIMPLE_OPTIMIZATIONS"
      }
    end
    
    it "loads asset definitions" do
      rapper = Rapper::Engine.new( "spec/fixtures/config/assets.yml", "test" )
      rapper.send( :asset_types ).sort.should == ["javascripts", "stylesheets", "validators"]
      rapper.definitions["stylesheets"]["source_root"].should == "spec/fixtures/stylesheets"
      rapper.definitions["stylesheets"]["suffix"].should == "css"
      # Using a YAML::OMap here, so it looks a bit weird
      rapper.definitions["stylesheets"]["assets"].first.key?( "master" ).should be_true
      rapper.definitions["stylesheets"]["assets"].first["files"].should == ["reset", "base", "layout"]
    end
  end
  
  describe "logging" do
    it "is off by default"
    it "can log to stdout"
    it "can log to a file"
  end
  
  describe "packaging test cases" do
    def file_names( path )
      Dir[path].map do |path|
        File.basename( path )
      end
    end
    
    Dir["spec/test_cases/*"].each do |folder|
      next unless File.directory?( folder )
      name = folder.split( "/" ).last
      results_path = "tmp/*.*"
      expecteds_path = "#{folder}/expected/*.*"
      
      it "passes the \"#{name}\" test case" do
        rapper = Rapper::Engine.new( "#{folder}/assets.yml", "test" )
        rapper.package
        
        # Produces the same exact individual files
        file_names( results_paths ).should == file_names( expecteds_paths )
        # Contents are all the same
        results = Dir[results_path]
        expecteds = Dir[expecteds_path]
        
        results.each_index do |i|
          unless File.read( results[i] ) == File.read( expecteds[i] )
            # p File.read( results[i] )
            raise "#{results[i]} did not match #{expecteds[i]}"
          end
        end
      end
    end
  end
  
  describe "bundling" do
    it "raises an error if a file doesn't exist"
  end
  
  describe "compressing" do
    it "can be turned off"
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
