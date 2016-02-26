# TODO: move the model.coffee to the repo
# TODO: move the package.json to the repo
$(document).ready ->
  editor = Editor.create({ tileSize: 48, tileOffset: 2 })
  editor.tilesets().create({ imagePath: '/images/tiles.png', cols: 12, rows: 12, uniqId: 'base' })
  editor.tilesets().create({ imagePath: 'http://rogue.epixx.org/images/Home_20110311_1.png', cols: 6, rows: 5, uniqId: 'another' })
  editor.render()

  # map = editor.maps().create({ cols: 20, rows: 15 })
  # map.tiles().create({ x: 10, y: 10, type: editor._tilesSet()[0] })
  # map.tiles().create({ x: 11, y: 10, type: editor._tilesSet()[1] })
  # map.tiles().create({ x: 10, y: 11, type: editor._tilesSet()[2] })
  # editor.render ->
  #   map.prepareCanvas()
  #   map.render()
  #
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
