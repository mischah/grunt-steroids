module.exports = (grunt) ->
  grunt.loadNpmTasks "grunt-extend-config"

  grunt.registerTask 'steroids-setup-cloud-resources', ->
    grunt.task.run [
      'steroids-convert-cloud-raml-to-js'
      'steroids-inject-cloud-resources-js'
    ]

  ###
  # 2: rewrite <head> for html files in dist to inject cloud-resources.js
  ###
  grunt.extendConfig {
    'steroids-inject-cloud-resources-js':
      dist:
        src: 'dist/app/**/*.html'
  }
  grunt.registerMultiTask 'steroids-inject-cloud-resources-js', ->
    count = 0
    @files.forEach (pair) ->
      pair.src.forEach (src) ->
        grunt.file.copy src, src,
          process: (contents) ->
            contents.replace /<head>/g, """
              <head>
                <!-- Cloud resource definition file for Supersonic Data -->
                <script src="/cloud-resources.js" />
            """
        grunt.log.debug "Injected cloud-resources.js to #{src}"
        count++
    grunt.log.ok "Processed #{count} files"

  ###
  # 1: convert config/cloud-resources.raml to dist/cloud-resources.js
  ###
  grunt.extendConfig {
    'steroids-convert-cloud-raml-to-js':
      options:
        src: 'config/cloud-resources.raml'
        dest: 'dist/cloud-resources.js'
  }
  grunt.registerTask 'steroids-convert-cloud-raml-to-js', ->
    {src, dest} = @options()

    # Found raml?
    try
      grunt.file.copy src, 'dist/cloud.raml'
      grunt.log.ok "Wrote dist/cloud.raml"
    catch e
      grunt.log.error "Couldn't read #{src}"

    # Generate js
    grunt.file.write dest, """
      (function(window) {
        var _base;
        if (window.ag == null) {
          window.ag = {};
        }
        if ((_base = window.ag).data == null) {
          _base.data = {};
        }
        return window.ag.data.resources = {
          options: {
            baseUri: 'http://rest-api.testgyver.com/v1',
            headers: {
              steroidsApiKey: '28e8afec12e2e21c4a59c6895ce2b51186a52e2bb989d51eb774caafa32d96de',
              steroidsAppId: 11638
            }
          },
          resources: {
            task: {
              schema: {
                fields: {
                  uid: {
                    identity: true,
                    type: 'string'
                  },
                  description: {
                    type: 'string'
                  }
                }
              }
            }
          }
        };
      })(window);
    """
    grunt.log.ok "Wrote #{dest}"
