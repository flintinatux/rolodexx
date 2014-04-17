exports.config =
  conventions:
    assets: /(assets|font)/

  files:
    javascripts:
      joinTo:
        'javascripts/app.js': /^app\/scripts/
        'javascripts/vendor.js': /^(bower_components|vendor\/scripts)/
      order:
        before: [
          'bower_components/jquery/dist/jquery.js'
          'bower_components/underscore/underscore.js'
          'bower_components/backbone/backbone.js'
        ]
        after: [
          'vendor/scripts/backbone_validation_bootstrap.coffee'
        ]

    stylesheets:
      joinTo:
        'stylesheets/app.css': /^app\/styles/

    templates:
      joinTo: 'javascripts/app.js'

  modules:
    nameCleaner: (path) ->
      path.replace /^app\/scripts\//, ''

  server:
    port: 3000
