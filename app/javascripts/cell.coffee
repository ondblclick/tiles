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

  adjustImage: (origin) ->
    color = @tile().tileSet().tileOpacityColor.split(',')
    data = origin.data
    i = 0
    while i < data.length
      if data[i] == +color[0] and +data[i + 1] == +color[1] and data[i + 2] == +color[2]
        data[i + 3] = 0
      i += 4
    origin

  render: (context) ->
    context = context or @layer().scene().context()
    buffer = utils.canvas.create(@game().tileSize, @game().tileSize)
    bufferContext = buffer.getContext('2d')
    bufferContext.drawImage(
      @tile().tileSet().img,
      @tile().x,
      @tile().y,
      @game().tileSize,
      @game().tileSize,
      0,
      0,
      @game().tileSize,
      @game().tileSize
    )
    adjusted = @adjustImage(bufferContext.getImageData(0, 0, 48, 48))
    bufferContext.putImageData(adjusted, 0, 0)

    context.drawImage(
      buffer,
      0,
      0,
      @game().tileSize,
      @game().tileSize,
      @col * @game().tileSize,
      @row * @game().tileSize,
      @game().tileSize,
      @game().tileSize
    )

module.exports = Cell
