module.exports = function(grunt) {

    // Project configuration.
    grunt.initConfig({

        jekyll: {
            options: {
                bundleExec: true,
            },
            dev : {
                options: {
                    serve: true,
                    watch: true,
                    src: '.',
                    server_port: 4000,
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

        watch: { // for development run 'grunt watch'
            jekyll: {
                files: ['templates/*.html'],
                tasks: ['jekyll:dev']
            }
        }
    });

    // Default task. Run standard jekyll server.
    grunt.registerTask('default', ['jekyll:dev']);
    grunt.registerTask('compass', ['compass:dev']);

    // Plugin tasks
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-jekyll');
    grunt.loadNpmTasks('grunt-contrib-compass');


};
