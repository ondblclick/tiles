class @Tile extends Model
  belongsTo: -> [Map]
  fields: ['x', 'y', 'type']

  initialize: ->
    [@spriteX, @spriteY] = @type.split('-')
    @tileSize = @map().tileSize

  toJSON: ->
    x: @x
    y: @y
    type: @type

  render: -> @map().drawImage(@spriteX, @spriteY, @x * @tileSize, @y * @tileSize)

  @findByPosition: (position) -> Tile.where(position)[0]
