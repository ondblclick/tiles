class @Map extends Model
  @STYLES:
    GREY: 'rgba(0, 0, 0, .05)'
    WHITE: '#fff'

  hasMany: -> [Tile]
  belongsTo: -> [Editor]
  fields: ['cols', 'rows']

  initialize: ->
    @tileSize = @editor().tileSize
    @tileOffset = @editor().tileOffset

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
    @context().fillStyle = Map.STYLES.WHITE
    @context().fillRect(0, 0, @cols * @tileSize, @rows * @tileSize)

  _renderGrid: ->
    @context().fillStyle = Map.STYLES.GREY
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
