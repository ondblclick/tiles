$(document).ready ->
  Tile.create({ x: 10, y: 10, type: '10-1' })
  Tile.create({ x: 11, y: 10, type: '5-5' })
  Tile.create({ x: 10, y: 11, type: '10-1' })
  window.canvas = new Canvas()
