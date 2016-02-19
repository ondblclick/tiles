class @Tile extends TileCommon
  @inversed: { top: 'bottom', bottom: 'top', left: 'right', right: 'left' }

  @types:
    'emptyType':
      'left': ['emptyType', 'theType', 'someType', 'anotherType']
      'right': ['emptyType', 'theType', 'someType', 'anotherType']
      'top': ['emptyType', 'theType', 'someType', 'anotherType']
      'bottom': ['emptyType', 'theType', 'someType', 'anotherType']
    'theType':
      'left': ['theType', 'someType', 'anotherType']
      'right': ['emptyType', 'someType', 'anotherType']
      'top': ['emptyType', 'theType', 'anotherType']
      'bottom': ['emptyType', 'theType', 'someType']
    'someType':
      'left': ['emptyType', 'someType', 'anotherType']
      'right': ['emptyType', 'theType', 'anotherType']
      'top': ['emptyType', 'theType', 'someType']
      'bottom': ['theType', 'someType', 'anotherType']
    'anotherType':
      'left': ['emptyType', 'theType', 'anotherType']
      'right': ['emptyType', 'theType', 'someType']
      'top': ['theType', 'someType', 'anotherType']
      'bottom': ['emptyType', 'someType', 'anotherType']

  @findByPosition: (position) ->
    Tile.where(position)[0]

  fields: ['x', 'y', 'type']

  render: ->
    template = $.templates('#tile')
    $('.canvas').append(template.render(@))
