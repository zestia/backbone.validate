module.exports = function(grunt) {

  // Project configuration
  grunt.initConfig({
    pkg: '<json:backbone.validate.json>',
    meta: {
      banner: '/*! <%= pkg.title || pkg.name %> - v<%= pkg.version %> - ' +
        '<%= grunt.template.today("yyyy-mm-dd") %>\n' +
        '<%= pkg.homepage ? "* " + pkg.homepage + "\n" : "" %>' +
        '* Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author.name %>;' +
        ' Licensed <%= _.pluck(pkg.licenses, "type").join(", ") %> */'
    },
    clean: ["dist", "specs/js", "specs/junit"],
    coffee: {
      dev: {
        files: {
          'dist/<%= pkg.name %>.js': 'src/backbone.validate.coffee'
        }
      },
      test: {
        files: {
          'dist/<%= pkg.name %>.js': 'src/backbone.validate.coffee',
          'specs/js/*.js': 'specs/coffee/*.coffee'
        }
      }
    },
    concat: {
      dist: {
        src: ['<banner:meta.banner>', 'dist/<%= pkg.name %>.js'],
        dest: 'dist/<%= pkg.name %>.js'
      }
    },
    min: {
      dist: {
        src: ['<banner:meta.banner>', '<config:concat.dist.dest>'],
        dest: 'dist/<%= pkg.name %>.min.js'
      }
    },
    jasmine: {
      src: ['lib/jquery.min.js', 'lib/underscore.min.js', 'dist/backbone.validate.js'],
      specs: 'specs/js/*.js',
      junit: {
        output: 'specs/junit/'
      }
    },
    watch: {
      dev: {
        files: 'src/backbone.validate.coffee',
        tasks: 'clean coffee:dev'
      },
      test: {
        files: ['src/backbone.validate.coffee', 'specs/coffee/*.coffee'],
        tasks: 'clean clear coffee:test jasmine'
      }
    },
    jshint: {
      options: {
        curly: true,
        eqeqeq: true,
        immed: true,
        latedef: true,
        newcap: true,
        noarg: true,
        sub: true,
        undef: true,
        boss: true,
        eqnull: true,
        browser: true
      },
      globals: {
        jQuery: true
      }
    },
    uglify: {}
  });

  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-jasmine-runner');
  grunt.loadNpmTasks('grunt-clear');

  // Default task.
  grunt.registerTask('default', 'clean coffee:dev concat min');
  grunt.registerTask('dev', 'watch:dev');
  grunt.registerTask('test', 'clean coffee:test jasmine');
  grunt.registerTask('watch-test', 'watch:test');
};
