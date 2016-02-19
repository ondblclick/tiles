class @PseudoTile extends TileCommon
  fields: ['x', 'y']

  @findByPosition: (position) ->
    PseudoTile.where(position)[0]

  render: ->
    template = $.templates('#pseudo-tile')
    $('.canvas').append(template.render(@))
