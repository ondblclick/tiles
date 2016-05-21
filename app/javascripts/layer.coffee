Model = require 'activer'
Scene = require './scene.coffee'
Cell = require './cell.coffee'
tabTmpl = require('../templates/layer_tab.hbs')

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
    $("#scene-containers > li[data-model-id='#{@scene().id}'] .layers-list").append(tabTmpl(@toJSON()))

  removeFromEditor: ->
    $(".layers-list .nav-item[data-model-id='#{@id}']").remove()

  remove: ->
    @removeFromEditor()
    @destroy()

  # called in case scene size changes in order to keep cells collection up to date
  updateCellsList: ->
    @cells().forEach (cell) =>
      cell.remove() if cell.col > +@scene().width - 1
      cell.remove() if cell.row > +@scene().height - 1

module.exports = Layer
