module.exports = function(grunt) {

  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-jasmine');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-clear');

  // Project configuration
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),

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

    uglify: {
      dist: {
        src: ['<banner:meta.banner>', '<%= concat.dist.dest %>'],
        dest: 'dist/<%= pkg.name %>.min.js'
      }
    },

    jasmine: {
      test: {
        src: ['lib/jquery.min.js', 'lib/underscore.min.js', 'dist/backbone.validate.js'],
        options: {
          specs: 'specs/js/*.js',
          junit: {
            output: 'specs/junit/'
          }
        }
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
    }
  });

  // Default task.
  grunt.registerTask('default',    [ 'clean', 'coffee:dev', 'concat:dist', 'uglify:dist' ]);
  grunt.registerTask('dev',        [ 'watch:dev' ]);
  grunt.registerTask('test',       [ 'clean', 'coffee:test', 'jasmine:test' ]);
  grunt.registerTask('watch-test', [ 'watch:test' ]);
};
