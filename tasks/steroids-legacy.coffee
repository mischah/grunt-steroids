module.exports = (grunt) ->

  grunt.loadTasks("#{__dirname}/legacy")

  grunt.registerTask "steroids-legacy", "Compile a legacy app/ to dist/", [
    "steroids-copy-js-from-app"
    "steroids-compile-coffee"
    "steroids-concat-models"
    "steroids-compile-views"
  ]
