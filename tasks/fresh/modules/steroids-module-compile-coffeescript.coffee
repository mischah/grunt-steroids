
module.exports = (grunt)->

  grunt.loadNpmTasks "grunt-extend-config"
  grunt.loadNpmTasks "grunt-contrib-coffee"

  grunt.extendConfig {
    "steroids-module-compile-coffeescript":
      modules:
        expand: true
        cwd: 'app/'
        src: '*'
        dest: 'dist/app'
  }

  grunt.registerMultiTask "steroids-module-compile-coffeescript", "Compile Coffeescript from app/* to dist/*.coffee", ->
    modules = {}
    @files.forEach (file) ->
      [path] = file.src
      [ignore..., module] = path.split '/'
      modules["module-#{module}"] =
        options:
          join: true
        src: [
          "#{path}/index.coffee"
          "#{path}/**/*.coffee"
        ]
        dest: "#{file.dest}.js"
        ext: '.js'

    grunt.extendConfig { coffee: modules }
    for taskName, module of modules
      grunt.task.run "coffee:#{taskName}"
