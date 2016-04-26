Model = require 'activer'
Editor = require './editor.coffee'
TileSet = require './tileset.coffee'
Scene = require './scene.coffee'

class Game extends Model
  @attributes('tileSize')
  @belongsTo('Editor')
  @hasMany('TileSet', 'Scene')

module.exports = Game
