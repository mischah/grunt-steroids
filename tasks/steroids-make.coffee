
module.exports = (grunt) ->

  grunt.registerTask "steroids-make", "Create the dist/ folder that is copied to the device.", [
    "steroids-clean-dist"
    "steroids-copy-www"
    "steroids-copy-components"
    # "steroids-copy-js-from-app"
    # "steroids-compile-coffee"
    # "steroids-concat-models"
    # "steroids-compile-views"
    "steroids-configure"
  ]
