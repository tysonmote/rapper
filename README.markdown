# rapper

Static asset packager and compressor with versioning. Supports Merb and Sinatra out of the box.

Pre-alpha, of course.

## Notes

* Definition files are Yaml ordered mappings so that version updates, when rapper updates the version numbers and writes out the updated definition file, don't re-order anything in the file. This is especially useful when using git and working with many branches because it prevents nasty merge conflicts. Trust us. We've been there.

## Rapper configuration

Rapper is configured using a YAML file. Example:

    base: &base
      definition_root: config/assets
      tag_style: html # optional, [html, xhtml, html5], default: html5
    
    development:
      <<: *base
      bundle: false   # optional, default: true
      compress: false # optional, default: true
      versions: false # optional, default: true
    
    production:
      <<: *base
      bundle: true
      compress: true
      versions: true
      # optional, passed to Google Closure Compiler
      closure_compiler:
        # default: SIMPLE_OPTIMIZATIONS
        compilation_level: ADVANCED_OPTIMIZATIONS

## Packaging

Set up rapper with the config file and current environment:

    Rapper.setup( "config/assets.yml", "development" )

And away you go!

    Rapper.package

## Rapper definitions

The `definition_root` setting in the rapper config is a path to a folder containing more YAML files that defines the various types of bundles you want to build (eg. `stylesheets.yml`, `javascripts.yml`) Example definition file:

    --- !omap 
    - source_root: public/javascripts
    - destination_root: public/assets/javascripts
    - suffix: js
    - assets: 
      - base: 
        - files: 
          - mootools
      - stats: 
        - files: 
          - protovis
          - ext_js_full

The above definition will create two asset files: `public/assets/javascripts/base.js` and `public/assets/javascripts/stats.js` from the component files in `public/javascripts`.

## Versioning

If versioning is turned on in your config, version strings will be automatically added to / updated on definition files after packaging:

    --- !omap 
    - source_root: public/javascripts
    - destination_root: public/assets/javascripts
    - suffix: js
    - assets: 
      - base: 
        - files: 
          - mootools
        - version: 7b06
      - stats: 
        - files: 
          - protovis
          - ext_js_full
        - version: db62

These version strings are hashes of the asset file. This means that they will only change when the contents of the asset file change. Version strings are used to enforce good browser caching habits, especially when you have a far-future expires header configured on your web server. For example, suppose you had the following asset:

    <script type="text/javascript" src="/assets/milkshake.js?v=d3va"></script>

When the contents of the asset change, the version will change in the query string:

    <script type="text/javascript" src="/assets/milkshake.js?v=ae51"></script>

Browsers will automatically re-download and cache the new asset.

## To do

* Compress JS and CSS when set
* Merb view helpers
* Sinatra helpers

## Near-future to do

* Per-asset configuration overrides
* Rails helpers
* Watch for CoffeeScript changes and automatically compile
* Watch for Sass changes and automatically compile

## Contributing to rapper
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011 CrowdFlower. See LICENSE.txt for further details.

