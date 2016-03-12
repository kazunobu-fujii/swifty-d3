const path = require('path');
const webpack = require('webpack');

module.exports = {
  devtool: 'source-map',
  entry: './src/index',
  output: {
    path: 'build/',
    filename: 'bundle.js',
    publicPath: "/build/",
    libraryTarget: "var",
    library: "Paths"
  },
  module: {
    loaders: [{
      test: /\.(js)$/,
      loaders: ['babel'],
      include: path.join(__dirname, 'src')
    }]
  }
};
