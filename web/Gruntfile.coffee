module.exports = (grunt) ->
  grunt.loadNpmTasks('grunt-contrib-sass')
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.registerTask('default',['watch']);

  grunt.initConfig
    watch:
      coffee:
        files: 'public/coffee/**/*.coffee'
        tasks: ['coffee:compile']
      css:
        files: 'public/sass/**/*.scss'
        tasks: ['sass']

    coffee:
      compile:
        options:
          join: true
        files: 'public/js/yoround.js' : ['public/coffee/**/*.coffee']

    sass:
      dist:
        files: 'public/css/yoround.css' : 'public/sass/yoround.scss'

