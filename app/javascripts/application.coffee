$(document).ready ->
  editor = Editor.create({ imagePath: '/images/tiles.png', tileSize: 48, tileOffset: 2 })
  map = editor.maps().create({ width: 100, height: 100 })
  map.tiles().create({ x: 10, y: 10, type: '10-1' })
  map.tiles().create({ x: 11, y: 10, type: '5-5' })
  map.tiles().create({ x: 10, y: 11, type: '10-1' })
  map.render()
