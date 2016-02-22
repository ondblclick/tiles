$(document).ready ->
  Tile.create({ x: 1, y: 0, type: '10-1' })
  Tile.create({ x: 0, y: -1, type: '10-1' })
  Tile.create({ x: -1, y: 0, type: '10-1' })
  Tile.create({ x: 0, y: 1, type: '10-1' })
  Tile.create({ x: 0, y: 0, type: '10-1' })
  window.canvas = new Canvas()
