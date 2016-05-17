Model = require 'activer'
Game = require './game.coffee'
Layer = require './layer.coffee'
$ = require 'jquery'

class Scene extends Model
  @attributes('name', 'width', 'height')
  @belongsTo('Game')
  @hasMany('Layer', { dependent: 'destroy' })

  @STYLES:
    GREY: 'rgba(0, 0, 0, .05)'
    WHITE: '#fff'

  @WHITELISTED_FIELDS: ['name', 'width', 'height']

  canvas: -> $("#scene-containers > li[data-model-id='#{@id}'] canvas")

  context: -> @canvas()[0].getContext('2d')

  clear: ->
    @context().fillStyle = Scene.STYLES.WHITE
    @context().fillRect(0, 0, @width * @game().tileSize, @height * @game().tileSize)

  drawRect: (x, y) ->
    @context().fillRect(x, y, @game().tileSize, @game().tileSize)

  sortedLayers: ->
    @layers().sort (layerA, layerB) ->
      +layerA.order > +layerB.order

  render: ->
    @clear()
    @renderGrid()
    @sortedLayers().forEach (layer) -> layer.renderTerrain()

  renderGrid: ->
    @context().fillStyle = Scene.STYLES.GREY
    col = 0
    while col < @width
      row = 0
      while row < @height
        if (row % 2 is 0 and col % 2 is 1) or (row % 2 is 1 and col % 2 is 0)
          @drawRect(col * @game().tileSize, row * @game().tileSize)
        row++
      col++

  toJSON: ->
    res = super()
    res.layers = @sortedLayers().map((layer) -> layer.toJSON())
    res

  renderToEditor: ->
    tabTmpl = $.templates('#scene-tab')
    containerTmpl = $.templates('#scene-container')
    obj = @toJSON()
    obj.width *= @game().tileSize
    obj.height *= @game().tileSize
    tab = tabTmpl.render(@toJSON())
    container = containerTmpl.render(obj)
    $('#scene-tabs').append(tab)
    $('#scene-containers').append(container)
    @layers().forEach (layer) -> layer.renderToEditor()
    $("#scene-containers > li[data-model-id='#{@id}'] .layers-list li").first().addClass('active')
    @render()

  removeFromEditor: ->
    $("#scene-containers li[data-model-id='#{@id}']").remove()
    $("#scene-tabs li[data-model-id='#{@id}']").remove()

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
