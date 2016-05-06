Editor = require('./editor.coffee')
TileSet = require('./tileset.coffee')
Layer = require('./tileset.coffee')
$ = require('jquery')

$(document).ready ->
  editor = Editor.create({ tileSize: 48 })
  editor.tileSets().create({ imagePath: '/images/tiles.png', cols: 12, rows: 12, uniqId: 'base', tileOffset: 2 })
  editor.tileSets().create({ imagePath: '/images/tiles_2.png', cols: 6, rows: 5, uniqId: 'another', tileOffset: 0 })
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

  $(document).on 'click', '#save-to-localstorage', (e) ->
    name = saveNamePrompt()
    localStorage.setItem(name, JSON.stringify(editor.toJSON())) if name

  $(document).on 'click', '#open-from-localstorage', (e) ->
    name = openNamePrompt()
    json = JSON.parse(localStorage.getItem(name)) if name
    importMap(editor, json)

  importMap = (editor, json) ->
    editor.tileSize = json.tileSize
    TileSet.collection = []
    Layer.collection = []
    json.tileSets.forEach (tileSet) -> editor.tileSets().create(tileSet)
    json.layers.forEach (layer) ->
      l = editor.layers().create(layer)
      layer.tiles.forEach (tile) -> l.tiles().create(tile)
      editor.render ->
        editor.layers().forEach (layer) ->
          layer.prepareCanvas()
          layer.render()

  openNamePrompt = (wrong = false) ->
    str = "Pick a name of map to open: "
    str = "Wrong name. " + str if wrong
    name = window.prompt(str)
    if name
      unless localStorage.getItem(name)
        name = openNamePrompt(true)
    name

  saveNamePrompt = (wrong = false) ->
    str = "Set a name for a map"
    str = "Already in use. " + str if wrong
    name = window.prompt(str)
    if localStorage.getItem(name)
      name = saveNamePrompt(true)
    name
