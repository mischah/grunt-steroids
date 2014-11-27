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
      destination = file.dest.replace /views\//, ''

      # Extract context
      context = do ([
          whole
          module
          view
        ] = file.dest.match /app\/([^\/]*)\/views\/([^.]*)/) ->
          { view, module }

      # Skip layouting if it's a _fragment
      if (context.view.indexOf '_') is 0
        grunt.file.copy file.src, destination
        return

      # List of modules that this module depends on - used for including JS files
      context.modules = switch context.module
        when 'common' then ['common']
        else ['common', context.module]

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
      grunt.file.write destination, output
