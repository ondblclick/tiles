class @Map extends Model
  hasMany: -> [Tile]

  initialize: ->
    @tileSize = 48
    @tileOffset = 2
    @context = canvas.getContext('2d')
    @_bindings()
    @_renderNavPanel()
    @dragging = false
    @selectedTile = undefined

  drawImage: (srcX, srcY, dstX, dstY) ->
    @context.drawImage(sprite, srcX, srcY, 48, 48, dstX, dstY, 48, 48)

  render: =>
    @_clean()
    @_renderGrid()
    @_renderTiles()

  _clean: ->
    @context.fillStyle = '#fff'
    @context.fillRect(0, 0, 4800, 4800)

  _renderGrid: ->
    @context.fillStyle = 'rgba(0, 0, 0, .05)'
    col = 0
    while col < 100
      row = 0
      while row < 100
        if row % 2 is 0
          @context.fillRect(col * 48, row * 48, 48, 48) if col % 2 is 1
        else
          @context.fillRect(col * 48, row * 48, 48, 48) if col % 2 is 0
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
      pageX = Math.floor(e.offsetX / 48)
      pageY = Math.floor(e.offsetY / 48)
      [imageX, imageY] = @selectedTile.find('a').data('tile-type').split('-')
      @render()
      @context.globalAlpha = 0.3
      @drawImage(@_fromPosition(imageX), @_fromPosition(imageY), pageX * 48, pageY * 48)
      @context.globalAlpha = 1

    $(document).on 'mouseleave', '#canvas', =>
      @render()

    $(document).on 'click', '#canvas', (e) =>
      console.log e
      return unless @selectedTile
      currentX = Math.floor(e.offsetX / 48)
      currentY = Math.floor(e.offsetY / 48)
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
