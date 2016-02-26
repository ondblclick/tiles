class @Tile extends Model
  belongsTo: -> [Map, TileSet]
  fields: ['x', 'y', 'uniqId']

  initialize: ->
    [@spriteX, @spriteY] = @uniqId.split('-')
    @tileSize = @map().tileSize

  # toJSON: ->
  #   x: @x
  #   y: @y
  #   type: @type

  render: ->
    @map().context().drawImage(@tileset().image, srcX, srcY, @tileSize, @tileSize, dstX, dstY, @tileSize, @tileSize)

  @findByPosition: (position) -> Tile.where(position)[0]
