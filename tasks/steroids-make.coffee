
module.exports = (grunt) ->

  grunt.loadTasks("#{__dirname}/make")

  grunt.registerTask "steroids-make", "Create the dist/ folder that is copied to the device.", [
    "steroids-clean-dist"
    "steroids-copy-www"
    "steroids-copy-components"
    "steroids-configure"
    "steroids-compile-modules"
  ]
