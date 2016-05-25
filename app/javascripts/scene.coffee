Model = require 'activer'
Game = require './game.coffee'
Layer = require './layer.coffee'

tabTmpl = require '../templates/scene_tab.hbs'
containerTmpl = require '../templates/scene_container.hbs'

class Scene extends Model
  @attributes('name', 'width', 'height')
  @belongsTo('Game')
  @hasMany('Layer', { dependent: 'destroy' })
  @delegate('editor', 'Game')

  canvas: -> $("#scene-containers > li[data-model-id='#{@id}'] canvas")

  context: -> @canvas()[0].getContext('2d')

  renderCell: ({ x, y }) ->
    cells = []
    @sortedLayers().forEach (layer) ->
      cell = layer.cells().where({ col: x, row: y })[0]
      cells.push cell if cell

    if cells.length
      cells.forEach (cell) -> cell.render()
    else
      @context().clearRect(x * @game().tileSize, y * @game().tileSize, @game().tileSize, @game().tileSize)

  sortedLayers: ->
    @layers().sort (layerA, layerB) ->
      +layerA.order > +layerB.order

  render: ->
    @context().clearRect(0, 0, @width * @game().tileSize, @height * @game().tileSize)
    @sortedLayers().forEach (layer) -> layer.renderTerrain()

  toJSON: ->
    res = super()
    res.layers = @sortedLayers().map((layer) -> layer.toJSON())
    res

  renderToEditor: ->
    obj = @toJSON()
    obj.width *= @game().tileSize
    obj.height *= @game().tileSize
    obj.tileSize = @game().tileSize
    obj.tileSizeX2 = @game().tileSize * 2
    $('#scene-tabs').append(tabTmpl(@toJSON()))
    $('#scene-containers').append(containerTmpl(obj))
    @sortedLayers().forEach (layer) -> layer.renderToEditor()
    $("#scene-containers > li[data-model-id='#{@id}'] .layers-list > .nav-item").first().addClass('active')
    @render()

  removeFromEditor: ->
    $("#scene-containers li[data-model-id='#{@id}']").remove()
    $("#scene-tabs .nav-item[data-model-id='#{@id}']").remove()

  remove: ->
    @removeFromEditor()
    @destroy()

  updateAttributes: (attrs) =>
    cellsShouldBeUpdated = false

    if attrs.width and +@width isnt +attrs.width or attrs.height and +@height isnt +attrs.height
      cellsShouldBeUpdated = true

    for k, v of attrs
      @[k] = v if k in @constructor.fields

    if cellsShouldBeUpdated
      @layers().forEach (layer) -> layer.updateCellsList()

    @removeFromEditor()
    @renderToEditor()

module.exports = Scene
