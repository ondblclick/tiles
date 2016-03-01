$(document).ready ->
  editor = Editor.create({ tileSize: 48 })
  editor.tilesets().create({ imagePath: '/images/tiles.png', cols: 12, rows: 12, uniqId: 'base', tileOffset: 2 })
  editor.tilesets().create({ imagePath: '/images/tiles_2.png', cols: 6, rows: 5, uniqId: 'another', tileOffset: 0 })
  editor.layers().create({ cols: 10, rows: 10 })
  editor.render ->
    editor.layers().forEach (layer) ->
      layer.prepareCanvas()
      layer.render()

  $(document).on 'click', '#export-as-json', (e) ->
    window.prompt("Copy to clipboard: Ctrl+C, Enter", JSON.stringify(editor.toJSON()))

  $(document).on 'click', '#import-as-json', (e) ->
    json = JSON.parse(window.prompt("Paste valid JSON here"))
    editor.tileSize = json.tileSize
    TileSet.collection = []
    Layer.collection = []
    json.tileSets.forEach (tileSet) -> editor.tilesets().create(tileSet)
    json.layers.forEach (layer) ->
      l = editor.layers().create(layer)
      layer.tiles.forEach (tile) -> l.tiles().create(tile)
    editor.render ->
      editor.layers().forEach (layer) ->
        layer.prepareCanvas()
        layer.render()
