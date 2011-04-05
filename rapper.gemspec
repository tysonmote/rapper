# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rapper}
  s.version = "0.2.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tyson Tate"]
  s.date = %q{2011-04-05}
  s.description = %q{Static asset packager and compressor with versioning and built-in view helpers. Compresses files only when they need compressing.}
  s.email = %q{tyson@tysontate.com}
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.markdown"
  ]
  s.files = [
    ".document",
    ".rspec",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.markdown",
    "Rakefile",
    "VERSION",
    "lib/rapper.rb",
    "lib/rapper/compressors.rb",
    "lib/rapper/config.rb",
    "lib/rapper/definition.rb",
    "lib/rapper/errors.rb",
    "lib/rapper/helpers.rb",
    "lib/rapper/html_tags.rb",
    "lib/rapper/logging.rb",
    "lib/rapper/utils.rb",
    "lib/rapper/versioning.rb",
    "lib/tasks.rb",
    "lib/yui/css_compressor.rb",
    "rapper.gemspec",
    "spec/fixtures/config/asset_definitions/base/javascripts.yml",
    "spec/fixtures/config/asset_definitions/base/stylesheets.yml",
    "spec/fixtures/config/asset_definitions/custom_destination/javascripts.yml",
    "spec/fixtures/config/asset_definitions/missing_file/stylesheets.yml",
    "spec/fixtures/config/assets.yml",
    "spec/fixtures/javascripts/simple_1.js",
    "spec/fixtures/javascripts/simple_2.js",
    "spec/fixtures/stylesheets/simple_1.css",
    "spec/fixtures/stylesheets/simple_2.css",
    "spec/fixtures/test_cases/compression/assets.yml",
    "spec/fixtures/test_cases/compression/definitions/css.yml",
    "spec/fixtures/test_cases/compression/definitions/js.yml",
    "spec/fixtures/test_cases/compression/expected/javascripts/base.js",
    "spec/fixtures/test_cases/compression/expected/javascripts/base_reversed.js",
    "spec/fixtures/test_cases/compression/expected/stylesheets/base.css",
    "spec/fixtures/test_cases/compression/expected/stylesheets/base_reversed.css",
    "spec/fixtures/test_cases/concatenation/assets.yml",
    "spec/fixtures/test_cases/concatenation/definitions/css.yml",
    "spec/fixtures/test_cases/concatenation/definitions/js.yml",
    "spec/fixtures/test_cases/concatenation/expected/javascripts/base.js",
    "spec/fixtures/test_cases/concatenation/expected/javascripts/base_reversed.js",
    "spec/fixtures/test_cases/concatenation/expected/stylesheets/base.css",
    "spec/fixtures/test_cases/concatenation/expected/stylesheets/base_reversed.css",
    "spec/fixtures/yui_css/background-position.css",
    "spec/fixtures/yui_css/background-position.css.min",
    "spec/fixtures/yui_css/box-model-hack.css",
    "spec/fixtures/yui_css/box-model-hack.css.min",
    "spec/fixtures/yui_css/bug2527974.css",
    "spec/fixtures/yui_css/bug2527974.css.min",
    "spec/fixtures/yui_css/bug2527991.css",
    "spec/fixtures/yui_css/bug2527991.css.min",
    "spec/fixtures/yui_css/bug2527998.css",
    "spec/fixtures/yui_css/bug2527998.css.min",
    "spec/fixtures/yui_css/bug2528034.css",
    "spec/fixtures/yui_css/bug2528034.css.min",
    "spec/fixtures/yui_css/charset-media.css",
    "spec/fixtures/yui_css/charset-media.css.min",
    "spec/fixtures/yui_css/color.css",
    "spec/fixtures/yui_css/color.css.min",
    "spec/fixtures/yui_css/comment.css",
    "spec/fixtures/yui_css/comment.css.min",
    "spec/fixtures/yui_css/concat-charset.css",
    "spec/fixtures/yui_css/concat-charset.css.min",
    "spec/fixtures/yui_css/decimals.css",
    "spec/fixtures/yui_css/decimals.css.min",
    "spec/fixtures/yui_css/dollar-header.css",
    "spec/fixtures/yui_css/dollar-header.css.min",
    "spec/fixtures/yui_css/font-face.css",
    "spec/fixtures/yui_css/font-face.css.min",
    "spec/fixtures/yui_css/ie5mac.css",
    "spec/fixtures/yui_css/ie5mac.css.min",
    "spec/fixtures/yui_css/media-empty-class.css",
    "spec/fixtures/yui_css/media-empty-class.css.min",
    "spec/fixtures/yui_css/media-multi.css",
    "spec/fixtures/yui_css/media-multi.css.min",
    "spec/fixtures/yui_css/media-test.css",
    "spec/fixtures/yui_css/media-test.css.min",
    "spec/fixtures/yui_css/opacity-filter.css",
    "spec/fixtures/yui_css/opacity-filter.css.min",
    "spec/fixtures/yui_css/preserve-new-line.css",
    "spec/fixtures/yui_css/preserve-new-line.css.min",
    "spec/fixtures/yui_css/preserve-strings.css",
    "spec/fixtures/yui_css/preserve-strings.css.min",
    "spec/fixtures/yui_css/preserve_string.css",
    "spec/fixtures/yui_css/preserve_string.css.min",
    "spec/fixtures/yui_css/pseudo-first.css",
    "spec/fixtures/yui_css/pseudo-first.css.min",
    "spec/fixtures/yui_css/pseudo.css",
    "spec/fixtures/yui_css/pseudo.css.min",
    "spec/fixtures/yui_css/special-comments.css",
    "spec/fixtures/yui_css/special-comments.css.min",
    "spec/fixtures/yui_css/star-underscore-hacks.css",
    "spec/fixtures/yui_css/star-underscore-hacks.css.min",
    "spec/fixtures/yui_css/string-in-comment.css",
    "spec/fixtures/yui_css/string-in-comment.css.min",
    "spec/fixtures/yui_css/zeros.css",
    "spec/fixtures/yui_css/zeros.css.min",
    "spec/rapper_spec.rb",
    "spec/spec_helper.rb",
    "spec/vendor_spec.rb"
  ]
  s.homepage = %q{http://tysontate.github.com/rapper/}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.4.2}
  s.summary = %q{Static asset packager and compressor with versioning and built-in view helpers.}
  s.test_files = [
    "spec/rapper_spec.rb",
    "spec/spec_helper.rb",
    "spec/vendor_spec.rb"
  ]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<closure-compiler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<rspec>, ["~> 1.3.1"])
      s.add_development_dependency(%q<yard>, ["~> 0.6.4"])
      s.add_development_dependency(%q<bluecloth>, ["~> 2.0.10"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.5.2"])
      s.add_development_dependency(%q<rake>, ["~> 0.8.7"])
    else
      s.add_dependency(%q<closure-compiler>, ["~> 1.0.0"])
      s.add_dependency(%q<rspec>, ["~> 1.3.1"])
      s.add_dependency(%q<yard>, ["~> 0.6.4"])
      s.add_dependency(%q<bluecloth>, ["~> 2.0.10"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
      s.add_dependency(%q<rake>, ["~> 0.8.7"])
    end
  else
    s.add_dependency(%q<closure-compiler>, ["~> 1.0.0"])
    s.add_dependency(%q<rspec>, ["~> 1.3.1"])
    s.add_dependency(%q<yard>, ["~> 0.6.4"])
    s.add_dependency(%q<bluecloth>, ["~> 2.0.10"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
    s.add_dependency(%q<rake>, ["~> 0.8.7"])
  end
end

