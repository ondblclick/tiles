Model = require 'activer'
TileSet = require './tileset.coffee'
Scene = require './scene.coffee'

class Game extends Model
  @attributes('tileSize')
  @hasMany('TileSet')
  @hasMany('Scene')

  toJSON: ->
    res = super()
    res.tileSets = @tileSets().map((tileSet) -> tileSet.toJSON())
    res.scenes = @scenes().map((scene) -> scene.toJSON())
    res

module.exports = Game
