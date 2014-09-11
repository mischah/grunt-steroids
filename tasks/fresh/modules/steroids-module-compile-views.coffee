
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
      layout = grunt.file.read "app/#{context.module}/views/layout.html"

      # Render view into layout
      output = grunt.util._.template(layout) {
        yield:
          view: view
          viewName: context.view
          moduleName: context.module
          modules: context.modules
      }

      # Write file
      destination = file.dest.replace /views\//, ''

      grunt.file.write destination, output
