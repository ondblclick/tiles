Model = require 'activer'
TileSet = require './tileset.coffee'
Scene = require './scene.coffee'

class Game extends Model
  @attributes('tileSize')
  @hasMany('TileSet')
  @hasMany('Scene')

module.exports = Game
