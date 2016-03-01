class @Tile extends Model
  belongsTo: -> [Layer, TileSet]
  fields: ['x', 'y', 'uniqId']

  initialize: ->
    [@spriteX, @spriteY] = @uniqId.split('-')
    @tileSize = @layer().tileSize

  render: ->
    @layer().context().drawImage(@tileset().image(), @spriteX, @spriteY, @tileSize, @tileSize, @x * @tileSize, @y * @tileSize, @tileSize, @tileSize)

  @findByPosition: (position) -> Tile.where(position)[0]
