class @Tile extends Model
  @findByPosition: (position) ->
    Tile.where(position)[0]

  belongsTo: -> [Map]
  fields: ['x', 'y', 'type']

  spriteX: -> @type.split('-')[0]
  spriteY: -> @type.split('-')[1]

  render: ->
    @map().drawImage(@spriteX(), @spriteY(), @x * @map().tileSize, @y * @map().tileSize)
