var ExtractTextPlugin = require ('extract-text-webpack-plugin');
var HtmlWebpackPlugin = require('html-webpack-plugin');
var webpack = require('webpack');

module.exports = {
  entry: {
    index: './app/javascripts/index.js'
  },
  output: {
    path: './dist',
    filename: 'javascripts/index.js'
  },
  module: {
    loaders: [
      { test: /\.coffee$/, loader: 'coffee-loader' },
      { test: /\.scss$/, loader: ExtractTextPlugin.extract('css!sass') },
      { test: /\.hbs$/, loader: 'handlebars-loader' }
    ]
  },
  plugins: [
    new ExtractTextPlugin('stylesheets/index.css'),
    new HtmlWebpackPlugin({
      filename: 'index.html',
      template: 'app/index.html'
    }),
    new webpack.ProvidePlugin({
      '$': "jquery",
      'jQuery': "jquery",
      'window.Tether': "tether"
    })
  ]
};
