Model = require 'activer'
TileSet = require './tileset.coffee'
$ = require 'jquery'

class Tile extends Model
  @attributes('x', 'y')
  @belongsTo('TileSet')
  @hasMany('Terrain', { dependent: 'destroy' })

  el: ->
    $(".tile[data-model-id='#{@id}']")

  style: ->
    ".tile[data-model-id='#{@id}'] { background-position-x: -#{@x}px; background-position-y: -#{@y}px; }"

module.exports = Tile
