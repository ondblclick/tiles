Model = require 'activer'
Scene = require './scene.coffee'
Cell = require './cell.coffee'
$ = require 'jquery'

class Layer extends Model
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
    tabTmpl = $.templates('#layer-tab')
    tab = tabTmpl.render(@toJSON())
    $("#scene-containers > li[data-model-id='#{@scene().id}'] .layers-list").append(tab)

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

module.exports = Layer
