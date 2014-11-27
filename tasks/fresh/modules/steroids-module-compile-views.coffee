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

  # Files starting with _ are used as view fragments and are not standalone views
  isFragment = (filename) ->
    (filename.indexOf '_') is 0

  # List of modules that this module depends on - used for including JS files
  discoverModuleDependencies = (moduleName) ->
    switch moduleName
      when 'common' then ['common']
      else ['common', moduleName]

  extractContextFromFilepath = (filepath) ->
    [
      whole
      module
      view
    ] = file.dest.match /app\/([^\/]*)\/views\/([^.]*)/

    {
      view
      module
      modules: discoverModuleDependencies module
    }

  renderWithLayout = (source, destination, context) ->
    # Retrieve view content
    view = grunt.file.read source

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


  grunt.registerMultiTask "steroids-module-compile-views", "Compile views from app/*/views/ to dist/*", ->
    layouts = {}

    @files.forEach (file) ->
      destination = file.dest.replace /views\//, ''

      context = extractContextFromFilepath file.dest

      # Skip layouting if it's a _fragment
      if isFragment context.view
        grunt.file.copy file.src, destination
      else
        renderWithLayout file.src, destination, context

