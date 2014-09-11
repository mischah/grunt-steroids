fs = require 'fs'
path = require 'path'
chalk = require 'chalk'

module.exports = (grunt)->

  componentDir = (dependency) ->
    path.join process.cwd(), "www", "components", dependency

  isDependencyInstalled = (dependency) ->
    fs.existsSync componentDir dependency

  promptDependency = (dependency) ->
    # Is this really reasonable? Why not offer chance to run bower install instead?
    path = componentDir dependency
    console.log "#{chalk.bold.red("ERROR")}: bower dependency #{dependency} doesn't exist in #{path}"
    console.log "       To install dependencies run #{chalk.bold("$ steroids update")}"

  checkBowerDependencies = ->
    bowerJson = grunt.file.readJSON "./bower.json"
    for dependency, source of bowerJson.dependencies
      unless isDependencyInstalled dependency
        promptDependency dependency
        process.exit(1)

    console.log "Project has bower dependencies installed... #{chalk.green "OK"}"

  grunt.registerTask "steroids-check-project", "Is this a valid Steroids project?", ->
    checkBowerDependencies()