# TODO: move the model.coffee to the repo
# TODO: move the package.json to the repo
$(document).ready ->
  editor = Editor.create({ imagePath: '/images/tiles.png', tileSize: 48, tileOffset: 2, tilesCols: 11, tilesRows: 11 })
  map = editor.maps().create({ cols: 100, rows: 100 })
  map.tiles().create({ x: 10, y: 10, type: editor._tilesSet()[0] })
  map.tiles().create({ x: 11, y: 10, type: editor._tilesSet()[1] })
  map.tiles().create({ x: 10, y: 11, type: editor._tilesSet()[2] })
  map.render()
