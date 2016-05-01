Model = require 'activer'
TileSet = require './tileset.coffee'
$ = require 'jquery'

class Tile extends Model
  @attributes('x', 'y')
  @belongsTo('TileSet')

  select: ->
    $('.tile').removeClass('is-active')
    @el().addClass('is-active')
  
  el: ->
    $(".tile[data-model-id='#{@id}']")

  style: ->
    ".tile[data-model-id='#{@id}'] { background-position-x: -#{@x}px; background-position-y: -#{@y}px; }"

module.exports = Tile
