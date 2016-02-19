class @Canvas
  constructor: ->
    @_bindings()
    @_renderTiles()
    @_renderAddButtons()
    @dragging = false

  _renderAddButtons: ->
    tiles = Tile.all().filter (tile) ->
      return false if tile.neighbors().length is 4
      return true

    tiles.forEach (tile) ->
      emptyCells = tile.emptyNeighbors()
      emptyCells.forEach (emptyCell) ->
        pseudoTile = PseudoTile.findByPosition(emptyCell)
        PseudoTile.create(emptyCell).render() unless pseudoTile

  _renderTiles: ->
    Tile.create({ x: 1, y: 0, type: 'someType' })
    Tile.create({ x: 0, y: -1, type: 'theType' })
    Tile.create({ x: -1, y: 0, type: 'anotherType' })
    Tile.create({ x: 0, y: 1, type: 'theType' })
    Tile.create({ x: 0, y: 0, type: 'anotherType' })
    Tile.all().forEach (tile) -> tile.render()

  _bindings: ->
    $(document).on 'click', '.tile', (e) ->
      Tile.find($(e.currentTarget).data('model-id')).handleClick()

    $(document).on 'click', '.pseudo-tile', (e) ->
      PseudoTile.find($(e.currentTarget).data('model-id')).handleClick()

    $(document).on 'mousedown', 'body', (e) =>
      return if $(e.target).is('.tile')
      return if $(e.target).is('.pseudo-tile')
      @dragging = true
      @pageX = e.pageX
      @pageY = e.pageY

    $(document).on 'mousemove', (e) =>
      return unless @dragging
      deltaX = @pageX - e.pageX
      deltaY = @pageY - e.pageY
      matrix = $('.canvas').css('transform').split(',')
      translateX = parseInt(matrix[4])
      translateY = parseInt(matrix[5])
      $('.canvas').css('transform', "translate(#{translateX - deltaX}px, #{translateY - deltaY}px)")
      @pageX = e.pageX
      @pageY = e.pageY

    $(document).on 'mouseup', =>
      @dragging = false
