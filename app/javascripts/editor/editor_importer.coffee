Modal = require '../modal.coffee'
Tile = require '../tile.coffee'
Layer = require '../layer.coffee'
Scene = require '../scene.coffee'
TileSet = require '../tileset.coffee'
Cell = require '../cell.coffee'
Game = require '../game.coffee'
Chunk = require '../chunk.coffee'

importMenuTmpl = require '../../templates/toolbar_menus/import_menu.hbs'

class EditorImporter
  constructor: (@editor) ->
    @bindings()

  appendMenu: ->
    @editor.menubar().append(importMenuTmpl())

  bindings: ->
    $(document).on 'click', '#import-as-json', (e) ->
      e.stopPropagation()
      new Modal(
        fields:
          JSON: ''
        actions:
          Import: (data) ->
            state = JSON.parse(data.JSON.replace(/("[^"]*")|\s/g, "$1"))
            Chunk.dao()._collection = []
            Game.dao()._collection = state.Game.slice(0)
            Tile.dao()._collection = state.Tile.slice(0)
            TileSet.dao()._collection = state.TileSet.slice(0)
            Layer.dao()._collection = state.Layer.slice(0)
            Scene.dao()._collection = state.Scene.slice(0)
            Cell.dao()._collection = state.Cell.slice(0)
            @editor.import(Game.all()[0])
            @editor.render()
      ).show()

module.exports = EditorImporter
