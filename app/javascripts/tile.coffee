Model = require 'activer'
TileSet = require './tileset.coffee'
# $ = require 'jquery'

class Tile extends Model
  @attributes('x', 'y', 'display')
  @belongsTo('TileSet')
  @hasMany('Terrain', { dependent: 'destroy' })

  el: ->
    $(".tile[data-model-id='#{@id}']")

  style: ->
    ".tile[data-model-id='#{@id}'] { background-position-x: -#{@x}px; background-position-y: -#{@y}px; }"

  toggleVisibility: ->
    if @el().is('.is-visible')
      @display = 'is-hidden'
      @el().removeClass('is-visible').addClass('is-hidden')
    else
      @display = 'is-visible'
      @el().removeClass('is-hidden').addClass('is-visible')

module.exports = Tile
