class @Tile extends Model
  @types: tilesSet
  @findByPosition: (position) ->
    Tile.where(position)[0]

  belongsTo: -> [Map]
  fields: ['x', 'y', 'type']

  spriteCol: -> @type.split('-')[0]
  spriteRow: -> @type.split('-')[1]

  render: (context) ->
    @map().drawImage(@map()._fromPosition(@spriteCol()), @map()._fromPosition(@spriteRow()), @x * @map().tileSize, @y * @map().tileSize)
