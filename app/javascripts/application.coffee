$(document).ready ->
  Tile.create({ x: 1, y: 0, type: 'someType' })
  Tile.create({ x: 0, y: -1, type: 'theType' })
  Tile.create({ x: -1, y: 0, type: 'anotherType' })
  Tile.create({ x: 0, y: 1, type: 'theType' })
  Tile.create({ x: 0, y: 0, type: 'anotherType' })
  window.canvas = new Canvas()
