class @Tile extends Model
  belongsTo: -> [Map, TileSet]
  fields: ['x', 'y', 'uniqId']

  initialize: ->
    [@spriteX, @spriteY] = @uniqId.split('-')
    @tileSize = @map().tileSize

  render: ->
    @map().context().drawImage(@tileset().image(), @spriteX, @spriteY, @tileSize, @tileSize, @x * @tileSize, @y * @tileSize, @tileSize, @tileSize)

  @findByPosition: (position) -> Tile.where(position)[0]
