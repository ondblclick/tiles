Model = require 'activer'
Game = require './game.coffee'
Floor = require './floor.coffee'
$ = require 'jquery'

class Scene extends Model
  @attributes('name', 'width', 'height')
  @belongsTo('Game')
  @hasMany('Floor', { dependent: 'destroy' })

  toJSON: ->
    res = super()
    res.floors = @floors().map((floor) -> floor.toJSON())
    res

  renderToEditor: ->
    tabTmpl = $.templates('#scene-tab')
    containerTmpl = $.templates('#scene-container')
    tab = tabTmpl.render(@toJSON())
    container = containerTmpl.render(@toJSON())
    $('#scene-tabs').append(tab)
    $('#scene-containers').append(container)

    @floors().forEach (floor) -> floor.renderToEditor()
    $('[id*=floor-tabs], [id*=floor-containers]').each ->
      $(@).find('li').first().addClass('active')

  removeFromEditor: ->
    $(".scene-containers li[data-model-id='#{@id}']").remove()
    $(".scene-tabs li[data-model-id='#{@id}']").remove()

  remove: ->
    @removeFromEditor()
    @destroy()

module.exports = Scene
