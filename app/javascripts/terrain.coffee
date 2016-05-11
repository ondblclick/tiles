Model = require 'activer'
Cell = require './cell.coffee'
Tile = require './tile.coffee'
$ = require 'jquery'

class Terrain extends Model
  @belongsTo('Cell')
  @belongsTo('Tile')
  @delegate('game', 'Cell')

  render: ->
    attrs = [
      @tile().tileSet().img,
      @tile().x,
      @tile().y,
      @game().tileSize,
      @game().tileSize,
      @cell().col * @game().tileSize,
      @cell().row * @game().tileSize,
      @game().tileSize,
      @game().tileSize
    ]
    @cell().floor().context().drawImage(attrs...)

module.exports = Terrain
