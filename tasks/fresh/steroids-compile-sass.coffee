path = require "path"

module.exports = (grunt)->

  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-extend-config'

  grunt.registerTask 'steroids-compile-sass', "Compile SASS files if they exist", ->

    grunt.extendConfig
      sass:
        dist:
          files: [
            {
              expand: true
              cwd: 'app/'
              src: ['**/*.{scss, sass}', '!**/native-styles/**']
              dest: 'dist/app/'
              ext: '.css'
            }
            {
              expand: true
              cwd: 'www/'
              src: ['**/*.{scss, sass}', '!**/native-styles/**']
              dest: 'dist/'
              ext: '.css'
            }
          ]


    sassFiles = grunt.file.expand(['{app, www}/**/stylesheets/**/*.{scss, sass}', '!**/native-styles/**'])

    if sassFiles.length > 0
      console.log "SASS/SCSS files found, compiling..."
      grunt.task.run "sass:dist"
    else
      console.log "No SASS/SCSS found."
