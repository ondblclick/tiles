class @Tile extends Model
  @types: tilesSet
  @findByPosition: (position) ->
    Tile.where(position)[0]

  fields: ['x', 'y', 'type']

  spriteX: -> @type.split('-')[0]

  spriteY: -> @type.split('-')[1]

  render: (context) ->
    context.drawImage(sprite, @spriteX() * (48 + 2) + 2, @spriteY() * (48 + 2) + 2, 48, 48, @x * 48, @y * 48, 48, 48)
