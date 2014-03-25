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

        watch: { // for development run 'grunt watch'
            jekyll: {
                files: ['templates/*.html'],
                tasks: ['jekyll:dev']
            }
        }
    });

    // Default task. Run standard jekyll server.
    grunt.registerTask('default', ['jekyll:dev']);

    // Plugin tasks
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-jekyll');


};
