Model = require 'activer'
Scene = require './scene.coffee'
Cell = require './cell.coffee'
$ = require 'jquery'

class Floor extends Model
  @attributes('name')
  @belongsTo('Scene')
  @hasMany('Cell')

  @STYLES:
    GREY: 'rgba(0, 0, 0, .05)'
    WHITE: '#fff'

  afterCreate: ->
    @createCells()

  createCells: ->
    col = 0
    while col < @scene().width
      row = 0
      while row < @scene().height
        @cells().create({ row: row, col: col })
        row++
      col++

  canvas: -> $(".floor-container[data-model-id='#{@id}'] canvas")

  context: -> @canvas()[0].getContext('2d')

  render: ->
    @clear()
    @renderGrid()
    @renderTerrain()

  renderTerrain: ->
    @cells().map((cell) -> cell.render())

  clear: ->
    @context().fillStyle = Floor.STYLES.WHITE
    @context().fillRect(0, 0, @scene().width * @scene().game().tileSize, @scene().height * @scene().game().tileSize)

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
    @renderGrid()

  removeFromEditor: ->
    $(".floor-containers li[data-model-id='#{@id}']").remove()
    $(".floor-tabs li[data-model-id='#{@id}']").remove()
    
  drawRect: (x, y) ->
    @context().fillRect(x, y, @scene().game().tileSize, @scene().game().tileSize)

  remove: ->
    @cells().deleteAll()
    @removeFromEditor()
    @destroy()

  renderGrid: ->
    @context().fillStyle = Floor.STYLES.GREY
    col = 0
    while col < @scene().width
      row = 0
      while row < @scene().height
        if (row % 2 is 0 and col % 2 is 1) or (row % 2 is 1 and col % 2 is 0)
          @drawRect(col * @scene().game().tileSize, row * @scene().game().tileSize)
        row++
      col++

module.exports = Floor
