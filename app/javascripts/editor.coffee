Model = require('activer')
Layer = require('./layer.coffee')
TileSet = require('./tileset.coffee')
Tile = require('./tile.coffee')
$ = require('jquery')

class Editor extends Model
  @attributes('tileSize')
  @hasMany('Layer', 'TileSet')

  afterCreate: ->
    @_bindings()

  render: (cb) ->
    $('canvas').remove()
    $('.list-tiles').empty()
    promises = @tileSets().map (tileSet) -> tileSet.render()
    $.when(promises...).then -> cb()

  selectedTile: ->
    $('.list-tiles-item.active')

  selectedSet: ->
    @tileSets().filter((item) -> item.uniqId is $('.list-tiles-item.active').data('tileset-id'))[0]

  currentLayer: ->
    @layers()[0]

  toJSON: ->
    tileSize: @tileSize
    tileSets: @tileSets().map((tileSet) -> tileSet.toJSON())
    layers: @layers().map((layer) -> layer.toJSON())

  _bindings: ->
    $(document).on 'click', '#create-map', =>
      Tile.collection = []
      Layer.collection = []
      @layers().create({ cols: $('#map-width').val(), rows: $('#map-height').val() })
      @currentLayer().prepareCanvas()
      @currentLayer().render()

    $(document).on 'click', '#export-as-png', (e) =>
      $(e.currentTarget).attr('href', @currentLayer().canvas()[0].toDataURL('image/png'))

    $(document).on 'click', '.list-tiles-item', (e) ->
      $(e.currentTarget).toggleClass('active').siblings().removeClass('active')

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

    $(document).on 'mouseleave', 'canvas', =>
      @currentLayer().render()

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
        tileSetId: @selectedSet().id
      @currentLayer().render()

module.exports = Editor
