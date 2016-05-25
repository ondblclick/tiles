Model = require 'activer'
Layer = require './layer.coffee'
Tile = require './tile.coffee'
utils = require './utils.coffee'

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
    @buffer = utils.canvas.create(@game().tileSize, @game().tileSize)
    @bufferContext = @buffer.getContext('2d')

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
    @bufferContext.drawImage(
      @cachedTileSet.img,
      @cachedTile.x,
      @cachedTile.y,
      @cachedTileSize,
      @cachedTileSize,
      0,
      0,
      @cachedTileSize,
      @cachedTileSize
    )
    adjusted = @adjustImage(@bufferContext.getImageData(0, 0, 48, 48))
    @bufferContext.putImageData(adjusted, 0, 0)

    context.drawImage(
      @buffer,
      0,
      0,
      @cachedTileSize,
      @cachedTileSize,
      @col * @cachedTileSize,
      @row * @cachedTileSize,
      @cachedTileSize,
      @cachedTileSize
    )

module.exports = Cell
