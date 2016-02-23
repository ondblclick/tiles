class @Canvas
  constructor: ->
    @_bindings()
    @render()
    @_renderNavPanel()
    @dragging = false
    @selectedTile = undefined

  render: ->
    @_removeTiles()
    @_renderTiles()

  _removeTiles: ->
    $('.tile').remove()

  _renderNavPanel: ->
    template = $.templates('#tile-library-modal')
    $('.list-tiles').append(template.render({ data: tilesSet }))

  _renderTiles: ->
    Tile.all().forEach (tile) -> tile.render()

  _bindings: ->
    $(document).on 'click', '.pseudo-tile', (e) =>
      existingTile = Tile.findByPosition({ x: @currentX, y: @currentY })
      existingTile.destroy() if existingTile
      Tile.create({ x: @currentX, y: @currentY, type: @selectedTile.find('a').data('tile-type') })
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

    $(document).on 'mousedown', '.canvas', (e) =>
      return if $(e.target).is('.tile')
      return if $(e.target).is('.pseudo-tile')
      @dragging = true
      @pageX = e.pageX
      @pageY = e.pageY

    $('.canvas').on 'mousemove', (e) =>
      if @dragging
        deltaX = @pageX - e.pageX
        deltaY = @pageY - e.pageY
        matrix = $('.canvas').css('transform').split(',')
        translateX = parseInt(matrix[4])
        translateY = parseInt(matrix[5])
        $('.canvas').css('transform', "translate(#{translateX - deltaX}px, #{translateY - deltaY}px)")
        @pageX = e.pageX
        @pageY = e.pageY

      if @selectedTile
        return if $(e.target).is('.pseudo-tile')
        @currentX = Math.floor(e.offsetX / 48)
        @currentY = Math.floor(e.offsetY / 48)
        if $(e.target).is('.tile')
          @currentX += Math.floor($(e.target).position().left / 48)
          @currentY += Math.floor($(e.target).position().top / 48)
        $('.pseudo-tile').css('transform', "translate(#{@currentX * 48}px, #{@currentY * 48}px)")

    $(document).on 'mouseup', =>
      @dragging = false
