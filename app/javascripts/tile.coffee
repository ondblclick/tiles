class @Tile extends Model
  belongsTo: -> [Layer, TileSet]
  fields: ['x', 'y', 'uniqId']

  initialize: ->
    [@spriteX, @spriteY] = @uniqId.split('-')
    @tileSize = @layer().tileSize

  toJSON: ->
    x: @x
    y: @y
    id: @id
    tileset_id: @tileset_id
    uniqId: @uniqId

  render: ->
    @layer().context().drawImage(@tileset().image(), @spriteX, @spriteY, @tileSize, @tileSize, @x * @tileSize, @y * @tileSize, @tileSize, @tileSize)

  @findByPosition: (position) -> Tile.where(position)[0]
