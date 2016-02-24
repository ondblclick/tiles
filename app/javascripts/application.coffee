$(document).ready ->
  c = new Map()
  c.tiles().create({ x: 10, y: 10, type: '10-1' })
  c.tiles().create({ x: 11, y: 10, type: '5-5' })
  c.tiles().create({ x: 10, y: 11, type: '10-1' })
  c.render()
