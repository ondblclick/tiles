module.exports = function(config) {
  config.set({
    plugins: [
      'karma-jasmine',
      'karma-phantomjs-launcher',
      'karma-spec-reporter',
      'karma-browserify'
    ],

    preprocessors: {
      './app/javascripts/*.coffee': ['browserify'],
      './spec/*.coffee': ['browserify']
    },

    browserify: {
      transform: ['coffeeify'],
      extensions: ['.coffee']
    },

    browsers: ['PhantomJS'],
    frameworks: ['jasmine', 'browserify'],
    reporters: ['spec'],

    files: [
      './app/javascripts/*.coffee',
      './spec/*.coffee'
    ]
  });
}
