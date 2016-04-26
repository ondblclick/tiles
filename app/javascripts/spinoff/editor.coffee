Model = require 'activer'
Game = require './game.coffee'
$ = require 'jquery'
require('jsrender')($)

class Editor extends Model
  @attributes()
  @hasOne('Game')

  afterCreate: ->
    @bindings()

  bindings: ->

  render: ->
    @renderScenes()

  renderScenes: ->
    @game().scenes().forEach (scene) -> scene.renderToEditor()
    $('#scene-tabs > li:first-child').addClass('is-active')
    $('#scene-containers > li:first-child').addClass('is-active')

module.exports = Editor