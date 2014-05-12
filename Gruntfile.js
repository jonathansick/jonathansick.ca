module.exports = function(grunt) {

    // Project configuration.
    grunt.initConfig({

        jekyll: {
            options: {
                bundleExec: true,
            },
            dev : {
                options: {
                    serve: false,
                    watch: false,
                    src: '.',
                    // server_port: 4000,
                }
            },
        },

        compass: {
            dev: {
                options: {
                    config: 'assets/config.rb',
                    bundleExec: true,
                    sassDir: 'assets/sass',
                    cssDir: 'assets/css',
                }
            },
        },

        connect: {
            server: {
                options: {
                    hostname: 'localhost',
                    port: 4000,
                    base: '_site/',
                    livereload: true
                },
            }
        },

        watch: {
            options: {
                livereload: true,
            },
            content: {
                files: ['index.html', 'cv.html', 'publications.html',
                        'adsbibdesk/*.md',
                        'includes/*.html', '_layouts/*.html',
                        '_publications/**/.yml',
                        'assets/css/*.css'],
                tasks: ['jekyll:dev'],
            },
            sass: {
                files: ['assets/sass/**/*.scss'],
                tasks: ['compass:dev']
            },
            js: {
                files: ['js/**/*.js'],
                tasks: ['jshint'],
            },
        },
    });

    // Default task.
    grunt.registerTask('default', ['connect', 'watch']);

    // Plugin tasks
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-jekyll');
    grunt.loadNpmTasks('grunt-contrib-compass');
    grunt.loadNpmTasks('grunt-contrib-connect');
    grunt.loadNpmTasks('grunt-contrib-jshint');
};
