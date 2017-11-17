var HtmlWebpackPlugin = require('html-webpack-plugin');
var Promise = require("es6-promise").Promise
var fs = require('fs');
var path = require('path');

module.exports = {
  context: __dirname + "/src",
  entry: {
    'plunker.popup': './popup/index.coffee',
    'plunker.background':  './background/index.coffee',
    'plunker.content': './content/index.coffee',
    'plunker.content.www': './content/www/index.coffee',
    'plunker.options': './options/index.coffee'
  },
  output: {
    path: path.join(__dirname, 'build'),
    filename: '[name].bundle.js'
  },
  module: {
    loaders: [
      { test: /\.js$/, loader: 'ng-annotate-loader!babel!jshint', exclude: [/node_modules/] },
      { test: /\.coffee$/, loader: "ng-annotate-loader!coffee-loader" },
      { test: /\.html$/, loader: "html-loader" },
      { test: /\.htm$/, loader: 'ng-cache-loader?module=ng,prefix=src:**' },
      { test: /\.svg/, loader: 'ng-cache-loader?module=ng,prefix=src:**' },
      { test: /\.json$/, loader: 'ng-cache-loader?module=ng,prefix=src:**' },
      { test: /\.scss$/, loader: 'style-loader!css-loader!sass-loader' },
      { test: /\.png$/, loader: 'url-loader?limit=10240' }
    ]
  },
  plugins: [
    new HtmlWebpackPlugin({
      filename: 'options.html',
      template: './options/index.html.ejs',
      chunks: []
    }),
    new HtmlWebpackPlugin({
      title: 'Plunker Background',
      filename: 'background.html',
      template: 'background/index.html.ejs',
      inject:   'body',
      chunks: ['plunker.background']
    }),
    new HtmlWebpackPlugin({
      title: 'Plunker',
      filename: 'popup.html',
      template: 'popup/index.html.ejs',
      inject:   'body',
      chunks: ['plunker.popup']
    }),
    new HtmlWebpackPlugin({
      filename: 'manifest.json',
      template: './manifest.json.ejs',
      chunks: []
    }),
    {
      apply: function(compiler) {
        compiler.plugin('done', function() {
          try { fs.statSync('build/img'); } catch (e) { fs.mkdirSync('build/img'); }
          try { fs.statSync('build/_locales/en'); } catch (e) { fs.mkdirSync('build/_locales'); fs.mkdirSync('build/_locales/en'); }
          
          fs.writeFileSync('build/img/48.png', fs.readFileSync('src/img/48.png'));
          fs.writeFileSync('build/img/128.png', fs.readFileSync('src/img/128.png'));
          fs.writeFileSync('build/_locales/en/messages.json', fs.readFileSync('src/_locales/en/messages.json'));
        });
      }
    }
  ]
};