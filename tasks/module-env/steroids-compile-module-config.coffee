fs = require "fs"

module.exports = (grunt) ->
  grunt.registerTask "steroids-compile-module-config", ->
    grunt.task.run [
      'steroids-compile-env-js'
      'steroids-compile-appgyver-js'
    ]

  grunt.registerTask 'steroids-compile-env-js', ->
    envConfigFilename = "../config/env.json"
    unless fs.existsSync envConfigFilename
      throw new Error "Please run `cd .. && steroids module init` to create #{envConfigFilename}"

    envConfig = grunt.file.readJSON envConfigFilename

    compiledEnvFile = grunt.util._.template(grunt.file.read "templates/env.js") {
      config: envConfig
    }

    grunt.file.write "dist/env.js", compiledEnvFile

  grunt.registerTask 'steroids-compile-appgyver-js', ->
    moduleConfigFilename = "../config/module.json"
    unless fs.existsSync moduleConfigFilename
      throw new Error "Please run `cd .. && steroids module refresh` to create #{moduleConfigFilename}"

    moduleConfig = grunt.file.readJSON moduleConfigFilename

    compiledModuleFile = grunt.util._.template(grunt.file.read "templates/appgyver.js") {
      config: moduleConfig
    }

    grunt.file.write "dist/appgyver.js", compiledModuleFile
