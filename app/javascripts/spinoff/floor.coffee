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
    obj = @toJSON()
    obj.width = @scene().width * @scene().game().tileSize
    obj.height = @scene().height * @scene().game().tileSize
    container = containerTmpl.render(obj)
    $("#floor-tabs-#{@sceneId}").append(tab)
    $("#floor-containers-#{@sceneId}").append(container)

module.exports = Floor
