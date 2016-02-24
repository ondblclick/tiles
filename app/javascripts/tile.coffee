class @Tile extends Model
  @findByPosition: (position) ->
    Tile.where(position)[0]

  belongsTo: -> [Map]
  fields: ['x', 'y', 'type']

  initialize: -> [@spriteX, @spriteY] = @type.split('-')

  render: ->
    @map().drawImage(@spriteX, @spriteY, @x * @map().tileSize, @y * @map().tileSize)
