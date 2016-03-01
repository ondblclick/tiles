$(document).ready ->
  editor = Editor.create({ tileSize: 48 })
  editor.tilesets().create({ imagePath: '/images/tiles.png', cols: 12, rows: 12, uniqId: 'base', tileOffset: 2 })
  editor.tilesets().create({ imagePath: '/images/tiles_2.png', cols: 6, rows: 5, uniqId: 'another', tileOffset: 0 })
  editor.render()

  layer = editor.layers().create({ cols: 10, rows: 10 })
  layer.prepareCanvas()
  layer.render()

  # $(document).on 'click', '#export-as-json', (e) ->
  #   window.prompt("Copy to clipboard: Ctrl+C, Enter", JSON.stringify(editor.toJSON()))
  #
  # $(document).on 'click', '#import-as-json', (e) ->
  #   json = JSON.parse(window.prompt("Paste valid JSON here"))
  #
  #   editor = Editor.create
  #     imagePath: json.imagePath
  #     tileSize: json.tileSize
  #     tileOffset: json.tileOffset
  #     tilesCols: json.tilesCols
  #     tilesRows: json.tilesRows
  #
  #   json.maps.forEach (map) ->
  #     m = editor.maps().create({ cols: map.cols, rows: map.rows })
  #     return unless map.tiles
  #     map.tiles.forEach (tile) ->
  #       m.tiles().create(tile)
  #
  #   editor.render ->
  #     editor.maps().forEach (map) ->
  #       map.prepareCanvas()
  #       map.render()
