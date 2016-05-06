Model = require 'activer'
Game = require './game.coffee'
Floor = require './floor.coffee'
$ = require 'jquery'

class Scene extends Model
  @attributes('name', 'width', 'height')
  @belongsTo('Game')
  @hasMany('Floor', { dependent: 'destroy' })

  renderToEditor: ->
    tabTmpl = $.templates('#scene-tab')
    containerTmpl = $.templates('#scene-container')
    tab = tabTmpl.render(@toJSON())
    container = containerTmpl.render(@toJSON())
    $('#scene-tabs').append(tab)
    $('#scene-containers').append(container)

    @floors().forEach (floor) -> floor.renderToEditor()
    $('[id*=floor-tabs] > .tab').first().addClass('is-active')
    $('[id*=floor-containers] > li:first-child').addClass('is-active')

  removeFromEditor: ->
    $(".scene-containers li[data-model-id='#{@id}']").remove()
    $(".scene-tabs li[data-model-id='#{@id}']").remove()

  remove: ->
    @removeFromEditor()
    @destroy()

module.exports = Scene
