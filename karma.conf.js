module.exports = function(config) {
  config.set({
    plugins: [
      'karma-coffee-preprocessor',
      'karma-jasmine',
      'karma-phantomjs-launcher',
      'karma-spec-reporter'
    ],

    preprocessors: {
      './app/javascripts/*.coffee': ['coffee'],
      './spec/*.coffee': ['coffee']
    },

    browsers: ['PhantomJS'],
    frameworks: ['jasmine'],
    reporters: ['spec'],

    coffeePreprocessor: {
      options: { bare: true, sourceMap: false },
      transformPath: function(path) { return path.replace(/\.coffee$/, '.js') }
    },

    files: [
      'https://code.jquery.com/jquery-2.2.0.min.js',
      'https://cdnjs.cloudflare.com/ajax/libs/jsrender/0.9.73/jsrender.js',
      './app/javascripts/*.coffee',
      './spec/*.spec.coffee'
    ]
  });
}
