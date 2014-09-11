fs = require 'fs'

module.exports = (grunt)->

  grunt.loadNpmTasks "grunt-extend-config"

  grunt.extendConfig {
    "steroids-module-compile-views":
      app:
        expand: true
        cwd: 'app'
        src: ['*/views/**/*.html', '!**/layout.html']
        dest: 'dist/app/'
  }

  firstExistingFile = (files) ->
    for file in files
      if fs.existsSync file
        return file

  grunt.registerMultiTask "steroids-module-compile-views", "Compile views from app/*/views/ to dist/*", ->
    layouts = {}

    @files.forEach (file) ->
      # Extract context
      context = do ([
          whole
          module
          view
        ] = file.dest.match /app\/([^\/]*)\/views\/([^.]*)/) ->
          { view, module }

      context.modules = if context.module isnt 'common'
          [context.module, 'common']
        else
          ['common']

      # Retrieve view content
      view = grunt.file.read file.src

      # Retrieve layout template
      layoutPath = firstExistingFile [
        "app/#{context.module}/views/layout.html"
        "app/common/views/layout.html"
      ]

      # Render view into layout
      output = if layoutPath?
          layout = grunt.file.read layoutPath
          grunt.util._.template(layout) {
            yield:
              view: view
              viewName: context.view
              moduleName: context.module
              modules: context.modules
          }
        else
          view

      # Write file
      destination = file.dest.replace /views\//, ''

      grunt.file.write destination, output
