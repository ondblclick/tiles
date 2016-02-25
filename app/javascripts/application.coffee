# TODO: move the model.coffee to the repo
# TODO: move the package.json to the repo
$(document).ready ->
  editor = Editor.create({ imagePath: '/images/tiles.png', tileSize: 48, tileOffset: 2, tilesCols: 12, tilesRows: 12 })
  map = editor.maps().create({ cols: 20, rows: 15 })
  map.tiles().create({ x: 10, y: 10, type: editor._tilesSet()[0] })
  map.tiles().create({ x: 11, y: 10, type: editor._tilesSet()[1] })
  map.tiles().create({ x: 10, y: 11, type: editor._tilesSet()[2] })
  editor.render ->
    map.prepareCanvas()
    map.render()

  $(document).on 'click', '#export-as-json', (e) ->
    window.prompt("Copy to clipboard: Ctrl+C, Enter", JSON.stringify(editor.toJSON()))

  $(document).on 'click', '#import-as-json', (e) ->
    json = JSON.parse(window.prompt("Paste valid JSON here"))

    editor = Editor.create
      imagePath: json.imagePath
      tileSize: json.tileSize
      tileOffset: json.tileOffset
      tilesCols: json.tilesCols
      tilesRows: json.tilesRows

    json.maps.forEach (map) ->
      m = editor.maps().create({ cols: map.cols, rows: map.rows })
      return unless map.tiles
      map.tiles.forEach (tile) ->
        m.tiles().create(tile)

    editor.render ->
      editor.maps().forEach (map) ->
        map.prepareCanvas()
        map.render()
