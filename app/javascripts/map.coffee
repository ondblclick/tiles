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
    @prepareCanvas()
    @_bindings()

  canvas: -> $('.canvas-wrapper canvas')
  context: -> @canvas()[0].getContext('2d')

  prepareCanvas: ->
    @canvas().remove()
    $('.canvas-wrapper').append("<canvas width='#{@cols * @tileSize}' height='#{@rows * @tileSize}'></canvas>")

  _selectedTile: ->
    $('.list-tiles-item.active')

  drawImage: (srcX, srcY, dstX, dstY) ->
    @context().drawImage(@editor().sprite, srcX, srcY, @tileSize, @tileSize, dstX, dstY, @tileSize, @tileSize)

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
    @tiles().forEach (tile) => tile.render(@context)

  _bindings: ->
    $(document).off 'mousemove'
    $(document).on 'mousemove', (e) =>
      return unless $(e.target).is('#canvas')
      return unless @_selectedTile().length
      pageX = Math.floor(e.offsetX / @tileSize)
      pageY = Math.floor(e.offsetY / @tileSize)
      [imageX, imageY] = @_selectedTile().data('tile-type').split('-')
      @render()
      @context().fillStyle = Map.STYLES.WHITE
      @drawRect(pageX * @tileSize, pageY * @tileSize)
      @context().globalAlpha = 0.3
      @drawImage(imageX, imageY, pageX * @tileSize, pageY * @tileSize)
      @context().globalAlpha = 1

    $(document).off 'mouseleave', '#canvas'
    $(document).on 'mouseleave', '#canvas', =>
      @render()

    $(document).off 'click', '#canvas'
    $(document).on 'click', '#canvas', (e) =>
      return unless @_selectedTile().length
      currentX = Math.floor(e.offsetX / @tileSize)
      currentY = Math.floor(e.offsetY / @tileSize)
      existingTile = Tile.findByPosition({ x: currentX, y: currentY })
      existingTile.destroy() if existingTile
      @tiles().create({ x: currentX, y: currentY, type: @_selectedTile().data('tile-type') })
      @render()
