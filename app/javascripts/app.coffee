Editor = require './editor.coffee'
Tile = require './tile.coffee'
Layer = require './layer.coffee'
Scene = require './scene.coffee'
TileSet = require './tileset.coffee'
Cell = require './cell.coffee'
Game = require './game.coffee'
json = require './json.coffee'

$(document).ready ->
  Game.dao()._collection = json.Game.slice(0)
  Tile.dao()._collection = json.Tile.slice(0)
  TileSet.dao()._collection = json.TileSet.slice(0)
  Layer.dao()._collection = json.Layer.slice(0)
  Scene.dao()._collection = json.Scene.slice(0)
  Cell.dao()._collection = json.Cell.slice(0)

  window.editor = new Editor(Game.all()[0])
  editor.render()
