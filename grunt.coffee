# /*global module:false*/
module.exports = (grunt) ->

  # Project configuration
  grunt.initConfig
    pkg: '<json:backbone.validate.json>'
    meta:
      banner: '/*! <%= pkg.title || pkg.name %> - v<%= pkg.version %> - ' +
        '<%= grunt.template.today("yyyy-mm-dd") %>\n' +
        '<%= pkg.homepage ? "* " + pkg.homepage + "\n" : "" %>' +
        '* Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author.name %>;' +
        ' Licensed <%= _.pluck(pkg.licenses, "type").join(", ") %> */'
    coffee:
      compile:
        files:
          'dist/<%= pkg.name %>.js': 'src/backbone.validate.coffee'
    concat:
      dist:
        src: ['<banner:meta.banner>', 'dist/<%= pkg.name %>.js']
        dest: 'dist/<%= pkg.name %>.js'
    min:
      dist:
        src: ['<banner:meta.banner>', '<config:concat.dist.dest>']
        dest: 'dist/<%= pkg.name %>.min.js'
    #lint:
    #  files: ['grunt.js', 'src/**/*.js', 'test/**/*.js']
    watch:
      files: ['src/backbone.validate.coffee']
      tasks: 'coffee'
    jshint:
      options:
        curly: true
        eqeqeq: true
        immed: true
        latedef: true
        newcap: true
        noarg: true
        sub: true
        undef: true
        boss: true
        eqnull: true
        browser: true
      globals:
        jQuery: true
    uglify: {}

  # Default task.
  grunt.registerTask 'default', 'coffee concat min'
