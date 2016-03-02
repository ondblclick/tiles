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
    importMap(editor, json)

  importMap = (editor, json) ->
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

  $(document).on 'click', '#save-to-localstorage', (e) ->
    name = saveNamePrompt()
    localStorage.setItem(name, JSON.stringify(editor.toJSON())) if name

  $(document).on 'click', '#open-from-localstorage', (e) ->
    name = openNamePrompt()
    json = JSON.parse(localStorage.getItem(name))
    importMap(editor, json)

  openNamePrompt = (empty = false) ->
    str = "Pick a name of map to open: "
    str = "Wrong name. " + str if empty
    name = window.prompt(str)
    unless localStorage.getItem(name)
      name = openNamePrompt(true)
    name

  saveNamePrompt = (inUse = false) ->
    str = "Set a name for a map"
    str = "Already in use. " + str if inUse
    name = window.prompt(str)
    if localStorage.getItem(name)
      name = saveNamePrompt(true)
    name
