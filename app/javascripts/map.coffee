# TODO: make user able to pick the size of map or something
class @Map extends Model
  hasMany: -> [Tile]
  belongsTo: -> [Editor]

  fields: ['width', 'height']

  initialize: ->
    @tileSize = @editor().tileSize
    @tileOffset = @editor().tileOffset
    @context = canvas.getContext('2d')
    @_bindings()

  _selectedTile: ->
    $('.list-tiles-item.active')

  drawImage: (srcX, srcY, dstX, dstY) ->
    @context.drawImage(@editor().sprite, srcX, srcY, @tileSize, @tileSize, dstX, dstY, @tileSize, @tileSize)

  drawRect: (x, y) ->
    @context.fillRect(x, y, @tileSize, @tileSize)

  render: =>
    @_clean()
    @_renderGrid()
    @_renderTiles()

  _clean: ->
    @context.fillStyle = '#fff'
    @context.fillRect(0, 0, @width * @tileSize, @height * @tileSize)

  _renderGrid: ->
    @context.fillStyle = 'rgba(0, 0, 0, .05)'
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
    Tile.all().forEach (tile) => tile.render(@context)

  _fromPosition: (coord) ->
    coord * (@tileSize + @tileOffset) + @tileOffset

  _bindings: ->
    $(document).on 'click', '#export-as-png', (e) ->
      $(e.currentTarget).attr('href', canvas.toDataURL('image/png'))

    $(document).on 'mousemove', (e) =>
      return unless $(e.target).is('#canvas')
      return unless @_selectedTile().length
      pageX = Math.floor(e.offsetX / @tileSize)
      pageY = Math.floor(e.offsetY / @tileSize)
      [imageX, imageY] = @_selectedTile().find('a').data('tile-type').split('-')
      @render()
      @context.fillStyle = '#fff'
      @drawRect(pageX * @tileSize, pageY * @tileSize)
      @context.globalAlpha = 0.3
      @drawImage(imageX, imageY, pageX * @tileSize, pageY * @tileSize)
      @context.globalAlpha = 1

    $(document).on 'mouseleave', '#canvas', =>
      @render()

    $(document).on 'click', '#canvas', (e) =>
      return unless @_selectedTile().length
      currentX = Math.floor(e.offsetX / @tileSize)
      currentY = Math.floor(e.offsetY / @tileSize)
      existingTile = Tile.findByPosition({ x: currentX, y: currentY })
      existingTile.destroy() if existingTile
      @tiles().create({ x: currentX, y: currentY, type: @_selectedTile().find('a').data('tile-type') })
      @render()

    $(document).on 'click', '.list-tiles-item', (e) ->
      $(e.currentTarget).toggleClass('active').siblings().removeClass('active')
