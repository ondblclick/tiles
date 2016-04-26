Model = require('activer')
Tile = require('./tile.coffee')
Editor = require('./editor.coffee')
$ = require('jquery')

class Layer extends Model
  @STYLES:
    GREY: 'rgba(0, 0, 0, .05)'
    WHITE: '#fff'

  @attributes('cols', 'rows')
  @hasMany('Tile')
  @belongsTo('Editor')

  afterCreate: ->
    @tileSize = @editor().tileSize
    @tileOffset = @editor().tileOffset

  toJSON: ->
    cols: @cols
    rows: @rows
    id: @id
    tiles: @tiles().map((tile) -> tile.toJSON())

  canvas: -> $('.canvas-wrapper canvas')
  context: -> @canvas()[0].getContext('2d')

  prepareCanvas: ->
    @canvas().remove()
    $('.canvas-wrapper').append("<canvas width='#{@cols * @tileSize}' height='#{@rows * @tileSize}'></canvas>")

  drawRect: (x, y) ->
    @context().fillRect(x, y, @tileSize, @tileSize)

  render: =>
    @_cleanCanvas()
    @_renderGrid()
    @_renderTiles()

  _cleanCanvas: ->
    @context().fillStyle = Layer.STYLES.WHITE
    @context().fillRect(0, 0, @cols * @tileSize, @rows * @tileSize)

  _renderGrid: ->
    @context().fillStyle = Layer.STYLES.GREY
    col = 0
    while col < 100
      row = 0
      while row < 100
        if row % 2 is 0
          @drawRect(col * @tileSize, row * @tileSize) if col % 2 is 1
        else
          @drawRect(col * @tileSize, row * @tileSize) if col % 2 is 0
        row++
      col++

  _renderTiles: ->
    @tiles().forEach (tile) -> tile.render()

module.exports = Layer
