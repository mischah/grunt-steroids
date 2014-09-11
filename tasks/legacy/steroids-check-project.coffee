fs = require 'fs'
path = require 'path'
chalk = require 'chalk'
xml2js = require 'xml2js'

module.exports = (grunt) ->
  grunt.loadNpmTasks "grunt-extend-config"

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

  ensureXmlValidity = (filepath) ->
    data = fs.readFileSync filepath
    parser = new xml2js.Parser()
    parser.parseString data, (err, result) ->
      if err or !result?
        console.log """
        
          #{chalk.red.bold("#{filepath} is not valid XML")}
          #{chalk.red.bold("==============================")}

          It looks like your #{chalk.bold("#{filepath}")} file is not valid XML. Please ensure its validity.

          If the file is beyond recovery, you can create a new project with

            #{chalk.bold("$ steroids create projectName")}

          and copy the #{chalk.bold("#{filepath}")} over from the new project.

        """
        process.exit(1)

  grunt.registerMultiTask "steroids-check-project-xml", ->
    @files.forEach (file) ->
      ensureXmlValidity file.dest

    console.log "Project has valid XML configuration files... #{chalk.green "OK"}"

  grunt.registerTask "steroids-check-project", "Is this a valid Steroids project?", ->
    grunt.extendConfig
      "steroids-check-project-xml":
        www:
          expand: true
          src: "www/*.xml"

    checkBowerDependencies()
    
    grunt.task.run "steroids-check-project-xml"