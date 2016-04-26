Model = require 'activer'
Game = require './game.coffee'

class TileSet extends Model
  @attributes()
  @belongsTo('Game')

module.exports = TileSet
