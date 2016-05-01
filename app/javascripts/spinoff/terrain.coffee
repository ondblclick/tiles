Model = require 'activer'
Cell = require './cell.coffee'
Tile = require './tile.coffee'
$ = require 'jquery'

class Terrain extends Model
  @belongsTo('Cell', 'Tile')

  render: ->
    game = @cell().floor().scene().game()
    @cell().floor().context().drawImage(@tile().tileSet().img, @tile().x, @tile().y, game.tileSize, game.tileSize, @cell().col * game.tileSize, @cell().row * game.tileSize, game.tileSize, game.tileSize)

module.exports = Terrain
