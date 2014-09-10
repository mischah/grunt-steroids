
module.exports = (grunt)->

  grunt.loadNpmTasks "grunt-extend-config"

  grunt.extendConfig {
    "steroids-module-compile-coffeescript":
      modules:
        cwd: 'app'
        src: '*'
        dest: 'dist/app/'
  }

  grunt.registerMultiTask "steroids-module-compile-coffeescript", "Compile Coffeescript from app/* to dist/*.coffee", ->
    @files.forEach (file) ->
      [module] = file.src
 
      grunt.extendConfig
        coffee:
          modules:
            options:
              join: true
            src: [
              "#{file.cwd}/#{module}/index.coffee"
              "#{file.cwd}/#{module}/**/*.coffee"
            ]
            dest: "#{file.dest}/#{module}.js"
            ext: '.js'

      grunt.task.run "coffee:modules"
