path = require 'path'
fs = require 'fs'

module.exports = (wintersmith, callback) ->

  class PlatesPlugin extends wintersmith.ContentPlugin

    constructor: (@_filename, @_base, @_source) ->

    getFilename: ->
      "#{@_filename}.js"

    templateName: ->
      path.basename @_filename, ".html"

    render: (locals, contents, templates, callback) ->
      fs.readFile path.join(@_base, @_filename), (error, buffer) =>
        if error
          callback error
        else
          jst = "window.JST['#{@templateName()}'] = '#{buffer.toString().replace("\n", "")}'"
          callback null, new Buffer(jst)

  PlatesPlugin.fromFile = (filename, base, callback) ->
    fs.readFile path.join(base, filename), (error, buffer) ->
      if error
        callback error
      else
        callback null, new PlatesPlugin filename, base, buffer.toString()

  wintersmith.registerContentPlugin 'styles', '**/templates/*.html', PlatesPlugin
  callback()
