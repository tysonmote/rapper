require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Rapper do
  describe "setup" do
    it "loads configuration and environment" do
      lambda do
        Rapper.setup( "spec/fixtures/config/assets.yml", "test" )
      end.should_not raise_error
    end
    
    it "bombs out if given a bad configuration file" do
      lambda do
        Rapper.setup( "spec/fixtures/config/fake.yml", "test" )
      end.should raise_error( Errno::ENOENT )
    end
    
    it "bombs out if given an invalid environment" do
      lambda do
        Rapper.setup( "spec/fixtures/config/assets.yml", "error" )
      end.should raise_error( Rapper::Errors::InvalidEnvironment )
    end
    
    it "uses the given environment's specific config" do
      Rapper.setup( "spec/fixtures/config/assets.yml", "test" )
      Rapper.environment.should == "test"
      # private
      Rapper.env_config["bundle"].should be_true
      Rapper.env_config["compress"].should be_true
      Rapper.env_config["version"].should be_false
    end
    
    it "loads asset definitions" do
      Rapper.setup( "spec/fixtures/config/assets.yml", "test" )
      Rapper.send( :asset_types ).sort.should == ["javascripts", "stylesheets", "validators"]
    end
  end
  
  describe "logging" do
    it "is off by default"
    it "can log to stdout"
    it "can log to a file"
  end
  
  describe "bundling" do
    it "can be turned off"
    it "concatenates files"
  end
  
  describe "compressing" do
    it "can be turned off"
    it "compresses, if configured to"
  end
end

describe Closure::Compiler do
  it "shoud be available" do
    closure = Closure::Compiler.new
    closure.compile( "var x = 1; var y = 2;" ).should == "var x=1,y=2;\n"
  end
    
    it "provides whitespace-only, simple, and advanced compression" do
      # Taken from https://github.com/documentcloud/closure-compiler/blob/master/test/unit/test_closure_compiler.rb
      
      original = "window.hello = function(name) { return console.log('hello ' + name ); }; hello.squared = function(num) { return num * num; }; hello('world');"
      compiled_whitespace = "window.hello=function(name){return console.log(\"hello \"+name)};hello.squared=function(num){return num*num};hello(\"world\");\n"
      compiled_simple = "window.hello=function(a){return console.log(\"hello \"+a)};hello.squared=function(a){return a*a};hello(\"world\");\n"
      compiled_advanced = "window.a=function(b){return console.log(\"hello \"+b)};hello.b=function(b){return b*b};hello(\"world\");\n"
      
      Closure::Compiler.new( :compilation_level => "WHITESPACE_ONLY" ).compile(original).should == compiled_whitespace
      Closure::Compiler.new.compile(original).should == compiled_simple
      Closure::Compiler.new( :compilation_level => "ADVANCED_OPTIMIZATIONS" ).compile(original).should == compiled_advanced
    end
end

describe YUI::CSSCompressor do
  # Originally from: https://github.com/rhulse/ruby-css-toolkit/blob/master/test/yui_compressor_test.rb
  test_files = Dir[File.join( File.dirname( __FILE__ ), '/fixtures/yui_css/*.css' )]
  test_files.each_with_index do |file, i|
    test_css = File.read(file)
    expected_css = File.read( file + '.min' )
    test_name = File.basename( file, ".css" )
    
    it "passes #{test_name} test" do
      YUI::CSSCompressor.compress( test_css ).should == expected_css
    end
  end
end
