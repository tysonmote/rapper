require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = "rapper"
  gem.homepage = "http://dolores.github.com/rapper/"
  gem.license = "MIT"
  gem.summary = %Q{Static asset packager and compressor with versioning.}
  gem.description = %Q{Static asset packager and compressor with versioning. Built-in support for CoffeeScript, Sass, Merb, and Sinatra.}
  gem.email = "tyson@doloreslabs.com"
  gem.authors = ["Tyson Tate", "Chris van Pelt"]
  
  # Runtime dependencies
  gem.add_runtime_dependency "yui-compressor", "~> 0.9.3"
  
  # Development dependencies
  gem.add_development_dependency "rspec", "~> 1.3.1"
  gem.add_development_dependency "yard", "~> 0.6.4"
  gem.add_development_dependency "bluecloth", "~> 2.0.10"
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

require 'yard'
YARD::Rake::YardocTask.new do |config|
  config.options = ["--private", "--protected"]
end