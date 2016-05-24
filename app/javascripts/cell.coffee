Model = require 'activer'
Layer = require './layer.coffee'
Tile = require './tile.coffee'

class Cell extends Model
  @belongsTo('Layer')
  @hasOne('Terrain')
  @belongsTo('Tile')
  @attributes('col', 'row')
  @delegate('game', 'Layer')

  afterCreate: ->
    @cachedTile = @tile()
    @cachedTileSet = @tile().tileSet()
    @cachedGame = @game()
    @cachedContext = @layer().scene().context()
    @cachedColor = @tile().tileSet().tileOpacityColor.split(',')
    @cachedTileSize = @cachedGame.tileSize
    @cachedBufferCtx = $('#buffer')[0].getContext('2d')
    @cachedBuffer = $('#buffer')[0]

  adjustImage: (origin) ->
    data = origin.data
    i = 0
    while i < data.length
      if data[i] == +@cachedColor[0] and +data[i + 1] == +@cachedColor[1] and data[i + 2] == +@cachedColor[2]
        data[i + 3] = 0
      i += 4
    origin

  # smells like shit
  render: (context = @cachedContext) ->
    attrs = [
      @cachedTileSet.img,
      @cachedTile.x,
      @cachedTile.y,
      @cachedTileSize,
      @cachedTileSize,
      0,
      0,
      @cachedTileSize,
      @cachedTileSize
    ]

    # TODO: работа с изображениями - узкое место
    # floodfill жутко тормозит при больших размерах сцены

    @cachedBufferCtx.drawImage(attrs...)
    adjusted = @adjustImage(@cachedBufferCtx.getImageData(0, 0, 48, 48))
    @cachedBufferCtx.putImageData(adjusted, 0, 0)

    attrs1 = [
      @cachedBuffer,
      0,
      0,
      @cachedTileSize,
      @cachedTileSize,
      @col * @cachedTileSize,
      @row * @cachedTileSize,
      @cachedTileSize,
      @cachedTileSize
    ]
    context.drawImage(attrs1...)

module.exports = Cell
