module.exports = (grunt) ->
  grunt.registerTask "steroids-make-fresh", "Create the dist/ folder that is copied to the device.", ->
    grunt.loadTasks("#{__dirname}/fresh")
    grunt.task.run [
      "steroids-check-project"
      "steroids-clean-dist"
      "steroids-copy-components"
      "steroids-configure"
      "steroids-compile-modules"
      "steroids-setup-cloud-resources"
    ]
