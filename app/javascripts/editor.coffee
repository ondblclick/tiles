class @Editor extends Model
  hasMany: -> [Layer, TileSet]
  fields: ['tileSize']

  initialize: ->
    @_bindings()

  render: (cb) ->
    $('canvas').remove()
    @tilesets().forEach (tileSet) -> tileSet.render()

  selectedTile: ->
    $('.list-tiles-item.active')

  selectedSet: ->
    utils.where(@tilesets(), { uniqId: $('.list-tiles-item.active').data('tileset-id') })[0]

  currentLayer: ->
    @layers()[0]

  _bindings: ->
    $(document).off 'click', '#create-map'
    $(document).on 'click', '#create-map', =>
      Tile.collection = []
      Layer.collection = []
      @layers().create({ cols: $('#map-width').val(), rows: $('#map-height').val() })
      @currentLayer().prepareCanvas()
      @currentLayer().render()

    $(document).off 'click', '#export-as-png'
    $(document).on 'click', '#export-as-png', (e) =>
      $(e.currentTarget).attr('href', @currentLayer().canvas()[0].toDataURL('image/png'))

    $(document).off 'click', '.list-tiles-item'
    $(document).on 'click', '.list-tiles-item', (e) ->
      $(e.currentTarget).toggleClass('active').siblings().removeClass('active')

    $(document).off 'mousemove'
    $(document).on 'mousemove', (e) =>
      return unless $(e.target).is('canvas')
      return unless @selectedTile().length
      pageX = Math.floor(e.offsetX / @tileSize)
      pageY = Math.floor(e.offsetY / @tileSize)
      [imageX, imageY] = @selectedTile().data('tile-id').split('-')
      @currentLayer().render()
      @currentLayer().context().fillStyle = Layer.STYLES.WHITE
      @currentLayer().drawRect(pageX * @tileSize, pageY * @tileSize)
      @currentLayer().context().globalAlpha = 0.3
      @currentLayer().context().drawImage(@selectedSet().image(), imageX, imageY, @tileSize, @tileSize, pageX * @tileSize, pageY * @tileSize, @tileSize, @tileSize)
      @currentLayer().context().globalAlpha = 1

    $(document).off 'mouseleave', 'canvas'
    $(document).on 'mouseleave', 'canvas', =>
      @currentLayer().render()

    $(document).off 'click', 'canvas'
    $(document).on 'click', 'canvas', (e) =>
      return unless @selectedTile().length
      currentX = Math.floor(e.offsetX / @tileSize)
      currentY = Math.floor(e.offsetY / @tileSize)
      existingTile = Tile.findByPosition({ x: currentX, y: currentY })
      existingTile.destroy() if existingTile
      @currentLayer().tiles().create
        x: currentX
        y: currentY
        uniqId: @selectedTile().data('tile-id')
        tileset_id: @selectedSet().id
      @currentLayer().render()
