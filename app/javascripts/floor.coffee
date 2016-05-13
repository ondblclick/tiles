Model = require 'activer'
Scene = require './scene.coffee'
Cell = require './cell.coffee'
$ = require 'jquery'

class Floor extends Model
  @attributes('name', 'order')
  @belongsTo('Scene')
  @hasMany('Cell', { dependent: 'destroy' })
  @delegate('game', 'Scene')

  toJSON: ->
    res = super()
    res.cells = @cells().map((cell) -> cell.toJSON())
    res

  renderTerrain: ->
    @cells().map((cell) -> cell.render())

  renderToEditor: ->
    tabTmpl = $.templates('#floor-tab')
    containerTmpl = $.templates('#floor-container')
    tab = tabTmpl.render(@toJSON())
    obj = @toJSON()
    obj.width = @scene().width * @game().tileSize
    obj.height = @scene().height * @game().tileSize
    container = containerTmpl.render(obj)
    $("#floor-tabs-#{@sceneId}").append(tab)
    $("#floor-containers-#{@sceneId}").append(container)
    @renderGrid()
    @renderTerrain()

  removeFromEditor: ->
    $(".layers-list li[data-model-id='#{@id}']").remove()

  remove: ->
    @removeFromEditor()
    @destroy()

  # called in case scene size changes in order to keep cells set up to date
  updateCellsList: ->
    @cells().forEach (cell) =>
      cell.remove() if cell.col > +@scene().width - 1
      cell.remove() if cell.row > +@scene().height - 1

module.exports = Floor
