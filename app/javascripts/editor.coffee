class @Editor extends Model
  hasMany: -> [Map, TileSet]
  fields: ['tileSize']

  initialize: ->
    @_bindings()

  render: (cb) ->
    $('canvas').remove()
    @tilesets().forEach (tileSet) ->
      tileSet.renderImage()
      tileSet.renderTiles()
      tileSet.renderStyles()

  _selectedTile: ->
    $('.list-tiles-item.active')

  _selectedTileSet: ->
    utils.where(@tilesets(), { uniqId: $('.list-tiles-item.active').data('tileset-id') })[0]

  currentMap: ->
    @maps()[0]

  _bindings: ->
    $(document).off 'click', '#create-map'
    $(document).on 'click', '#create-map', =>
      Tile.collection = []
      Map.collection = []
      @maps().create({ cols: $('#map-width').val(), rows: $('#map-height').val() })
      @maps()[0].prepareCanvas()
      @maps()[0].render()

    $(document).off 'click', '#export-as-png'
    $(document).on 'click', '#export-as-png', (e) =>
      $(e.currentTarget).attr('href', @maps()[0].canvas()[0].toDataURL('image/png'))

    $(document).off 'click', '.list-tiles-item'
    $(document).on 'click', '.list-tiles-item', (e) ->
      $(e.currentTarget).toggleClass('active').siblings().removeClass('active')

    $(document).off 'mousemove'
    $(document).on 'mousemove', (e) =>
      return unless $(e.target).is('canvas')
      return unless @_selectedTile().length
      pageX = Math.floor(e.offsetX / @tileSize)
      pageY = Math.floor(e.offsetY / @tileSize)
      [imageX, imageY] = @_selectedTile().data('tile-id').split('-')
      @currentMap().render()
      @currentMap().context().fillStyle = Map.STYLES.WHITE
      @currentMap().drawRect(pageX * @tileSize, pageY * @tileSize)
      @currentMap().context().globalAlpha = 0.3
      @currentMap().context().drawImage(@_selectedTileSet().image(), imageX, imageY, @tileSize, @tileSize, pageX * @tileSize, pageY * @tileSize, @tileSize, @tileSize)
      @currentMap().context().globalAlpha = 1

    $(document).off 'mouseleave', 'canvas'
    $(document).on 'mouseleave', 'canvas', =>
      @currentMap().render()

    $(document).off 'click', 'canvas'
    $(document).on 'click', 'canvas', (e) =>
      return unless @_selectedTile().length
      currentX = Math.floor(e.offsetX / @tileSize)
      currentY = Math.floor(e.offsetY / @tileSize)
      existingTile = Tile.findByPosition({ x: currentX, y: currentY })
      existingTile.destroy() if existingTile
      @currentMap().tiles().create
        x: currentX
        y: currentY
        uniqId: @_selectedTile().data('tile-id')
        tileset_id: @_selectedTileSet().id
      @currentMap().render()
