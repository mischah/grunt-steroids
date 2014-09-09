module.exports = (grunt) ->

  grunt.loadTasks("#{__dirname}/modules")

  grunt.registerTask "steroids-compile-modules", "Compile modules in app/ to device-ready files", [
    'steroids-module-copy-assets'
    'steroids-module-compile-views'
  ]
