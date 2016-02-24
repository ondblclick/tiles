$(document).ready ->
  editor = Editor.create({ imagePath: '/images/tiles.png', tileSize: 48, tileOffset: 2, tilesCols: 11, tilesRows: 11 })
  map = editor.maps().create({ width: 100, height: 100 })
  map.tiles().create({ x: 10, y: 10, type: Object.keys(editor._tilesSet())[0] })
  map.tiles().create({ x: 11, y: 10, type: Object.keys(editor._tilesSet())[1] })
  map.tiles().create({ x: 10, y: 11, type: Object.keys(editor._tilesSet())[2] })
  map.render()
