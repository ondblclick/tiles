Model = require('activer')
Layer = require('./layer.coffee')
TileSet = require('./tileset.coffee')

class Tile extends Model
  @attributes('x', 'y', 'uniqId')
  @belongsTo('Layer', 'TileSet')

  afterCreate: ->
    [@spriteX, @spriteY] = @uniqId.split('-')
    @tileSize = @layer().tileSize

  toJSON: ->
    x: @x
    y: @y
    id: @id
    tileSetId: @tileSetId
    uniqId: @uniqId

  render: ->
    @layer().context().drawImage(@tileSet().image(), @spriteX, @spriteY, @tileSize, @tileSize, @x * @tileSize, @y * @tileSize, @tileSize, @tileSize)

  @findByPosition: (position) -> Tile.where(position)[0]

module.exports = Tile
