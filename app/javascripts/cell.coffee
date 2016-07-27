Model = require 'activer'
Chunk = require './chunk.coffee'
Layer = require './layer.coffee'
Tile = require './tile.coffee'
utils = require './utils.coffee'

class Cell extends Model
  @belongsTo('Tile')
  @belongsTo('Layer')
  @attributes('col', 'row')
  @delegate('game', 'Layer')

  chunk: ->
    @layer().chunks().where({
      col: Math.floor(@col / Chunk.SIZE_IN_CELLS),
      row: Math.floor(@row / Chunk.SIZE_IN_CELLS)
    })[0]

  destroy: ->
    super()
    tileSize = @game().tileSize
    @chunk().context().clearRect(
      @col % Chunk.SIZE_IN_CELLS * tileSize,
      @row % Chunk.SIZE_IN_CELLS * tileSize
      tileSize,
      tileSize
    )

  adjustImage: (origin) ->
    color = @tile().tileSet().tileOpacityColor.split(',')
    data = origin.data
    i = 0
    while i < data.length
      if data[i] == +color[0] and +data[i + 1] == +color[1] and data[i + 2] == +color[2]
        data[i + 3] = 0
      i += 4
    origin

  render: ->
    tileSize = @game().tileSize
    context = @chunk().context()
    buffer = utils.canvas.create(tileSize, tileSize)
    bufferContext = buffer.getContext('2d')
    tile = @tile()

    bufferContext.drawImage(
      tile.tileSet().img,
      tile.x,
      tile.y,
      tileSize,
      tileSize,
      0,
      0,
      tileSize,
      tileSize
    )
    adjusted = @adjustImage(bufferContext.getImageData(0, 0, 48, 48))
    bufferContext.putImageData(adjusted, 0, 0)

    context.drawImage(
      buffer,
      0,
      0,
      tileSize,
      tileSize,
      @col % Chunk.SIZE_IN_CELLS * tileSize,
      @row % Chunk.SIZE_IN_CELLS * tileSize,
      tileSize,
      tileSize
    )

    $('body').append(@chunk().canvas)

module.exports = Cell
