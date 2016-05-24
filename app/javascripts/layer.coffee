Model = require 'activer'
Scene = require './scene.coffee'
Cell = require './cell.coffee'

tabTmpl = require '../templates/layer_tab.hbs'

class Layer extends Model
  @attributes('name', 'order')
  @belongsTo('Scene')
  @hasMany('Cell', { dependent: 'destroy' })
  @delegate('game', 'Scene')

  toJSON: ->
    res = super()
    res.cells = @cells().map((cell) -> cell.toJSON())
    res

  renderCellToHiddenCanvas: (pos) ->
    @cells().where({ col: pos.x, row: pos.y })[0].render(@canvas.getContext('2d'))

  removeCellFromHiddenCanvas: (pos) ->
    @canvas.getContext('2d').clearRect(pos.x * @game().tileSize, pos.y * @game().tileSize, @game().tileSize, @game().tileSize)

  afterCreate: ->
    @canvas = document.createElement('canvas')
    @canvas.height = @scene().height * @game().tileSize
    @canvas.width = @scene().width * @game().tileSize

  render: ->
    @renderTerrain()

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
