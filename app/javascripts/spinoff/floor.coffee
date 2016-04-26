Model = require 'activer'
Scene = require './scene.coffee'
$ = require 'jquery'

class Floor extends Model
  @attributes('name')
  @belongsTo('Scene')

  renderToEditor: ->
    tabTmpl = $.templates('#floor-tab')
    containerTmpl = $.templates('#floor-container')
    tab = tabTmpl.render(@toJSON())
    container = containerTmpl.render(@toJSON())
    $("#floor-tabs-#{@sceneId}").append(tab)
    $("#floor-containers-#{@sceneId}").append(container)

module.exports = Floor
