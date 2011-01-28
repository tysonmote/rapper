require 'rubygems'
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "rapper"
  gem.homepage = "http://github.com/dolores/rapper"
  gem.license = "MIT"
  gem.summary = %Q{Static asset packager and compressor with versioning.}
  gem.description = %Q{Static asset packager and compressor with versioning. Built-in support for CoffeeScript, Sass, Merb, and Sinatra.}
  gem.email = "tyson@doloreslabs.com"
  gem.authors = ["Chris van Pelt", "Tyson Tate"]
  # Include your dependencies below. Runtime dependencies are required when using your gem,
  # and development dependencies are only needed for development (ie running rake tasks, tests, etc)
  gem.add_runtime_dependency "yui-compressor", "~> 0.9.3"
  gem.add_development_dependency "rspec", "~> 1.3.1"
  gem.add_development_dependency "bundler", "~> 1.0.0"
  gem.add_development_dependency "jeweler", "~> 1.5.2"
end
Jeweler::RubygemsDotOrgTasks.new

require 'spec'
require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""
  
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "rapper #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
