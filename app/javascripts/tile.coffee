class @Tile extends TileCommon
  @inversed: { top: 'bottom', bottom: 'top', left: 'right', right: 'left' }

  @types: tilesSet

  @findByPosition: (position) ->
    Tile.where(position)[0]

  fields: ['x', 'y', 'type']

  render: ->
    template = $.templates('#tile')
    $('.canvas').append(template.render(@))
