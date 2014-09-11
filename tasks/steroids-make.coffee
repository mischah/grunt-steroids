module.exports = (grunt) ->

  grunt.loadTasks("#{__dirname}/legacy")

  grunt.registerTask "steroids-make", "Compile a legacy Steroids app/ to dist/", [
    "steroids-check-project"
    "steroids-clean-dist"
    "steroids-copy-js-from-app"
    "steroids-copy-www"
    "steroids-compile-coffee"
    "steroids-concat-models"
    "steroids-compile-views"
    "steroids-configure"
  ]
