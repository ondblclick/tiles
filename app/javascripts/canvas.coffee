class @Map extends Model
  hasMany: -> [Tile]

  fields: ['width', 'height', 'tileSize', 'tileOffset']

  initialize: ->
    @context = canvas.getContext('2d')
    @_bindings()
    @_renderNavPanel()
    @dragging = false
    @selectedTile = undefined

  drawImage: (srcX, srcY, dstX, dstY) ->
    @context.drawImage(sprite, srcX, srcY, @tileSize, @tileSize, dstX, dstY, @tileSize, @tileSize)

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

  _renderNavPanel: ->
    template = $.templates('#tile-library-modal')
    $('.list-tiles').append(template.render({ data: tilesSet }))

  _fromPosition: (coordinate) ->
    coordinate * (@tileSize + @tileOffset) + @tileOffset

  _bindings: ->
    $(document).on 'mousemove', (e) =>
      return unless $(e.target).is('#canvas')
      return unless @selectedTile
      pageX = Math.floor(e.offsetX / @tileSize)
      pageY = Math.floor(e.offsetY / @tileSize)
      [imageX, imageY] = @selectedTile.find('a').data('tile-type').split('-')
      @render()
      @context.fillStyle = '#fff'
      @drawRect(pageX * @tileSize, pageY * @tileSize)
      @context.globalAlpha = 0.3
      @drawImage(@_fromPosition(imageX), @_fromPosition(imageY), pageX * @tileSize, pageY * @tileSize)
      @context.globalAlpha = 1

    $(document).on 'mouseleave', '#canvas', => @render()

    $(document).on 'click', '#canvas', (e) =>
      return unless @selectedTile
      currentX = Math.floor(e.offsetX / @tileSize)
      currentY = Math.floor(e.offsetY / @tileSize)
      existingTile = Tile.findByPosition({ x: currentX, y: currentY })
      existingTile.destroy() if existingTile
      @tiles().create({ x: currentX, y: currentY, type: @selectedTile.find('a').data('tile-type') })
      @render()

    $(document).on 'click', '.list-tiles-item', (e) =>
      @selectedTile = $(e.currentTarget)
      @selectedTile.toggleClass('active').siblings().removeClass('active')
      @selectedTile = undefined unless @selectedTile.is('.active')
      if @selectedTile
        $('.pseudo-tile').css('background', @selectedTile.find('a').css('background'))
        $('.pseudo-tile').addClass('active')
      else
        $('.pseudo-tile').removeClass('active')
