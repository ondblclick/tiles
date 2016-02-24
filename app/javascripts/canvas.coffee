class @Canvas
  constructor: ->
    @context = canvas.getContext('2d')
    @_bindings()
    @render()
    @_renderNavPanel()
    @dragging = false
    @selectedTile = undefined

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

  _bindings: ->
    $(document).on 'mousemove', (e) =>
      return unless $(e.target).is('#canvas')
      return unless @selectedTile
      currentX = Math.floor(e.pageX / 48)
      currentY = Math.floor(e.pageY / 48)
      @render()
      @context.drawImage(sprite, @selectedTile.find('a').data('tile-type').split('-')[0] * (48 + 2) + 2, @selectedTile.find('a').data('tile-type').split('-')[1] * (48 + 2) + 2, 48, 48, currentX * 48, currentY * 48, 48, 48)
      # @context.fillStyle = '#ccc'
      # @context.fillRect(currentX * 48, currentY * 48, 48, 48)

    $(document).on 'mouseleave', '#canvas', =>
      @render()

    $(document).on 'click', '#canvas', (e) =>
      return unless @selectedTile
      currentX = Math.floor(e.pageX / 48)
      currentY = Math.floor(e.pageY / 48)
      existingTile = Tile.findByPosition({ x: currentX, y: currentY })
      existingTile.destroy() if existingTile
      Tile.create({ x: currentX, y: currentY, type: @selectedTile.find('a').data('tile-type') })
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
