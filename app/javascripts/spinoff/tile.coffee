Model = require 'activer'
TileSet = require './tileset.coffee'
$ = require 'jquery'

class Tile extends Model
  @attributes('x', 'y', 'display')
  @belongsTo('TileSet')
  @hasMany('Terrain', { dependent: 'destroy' })

  el: ->
    $(".tile[data-model-id='#{@id}']")

  style: ->
    ".tile[data-model-id='#{@id}'] { background-position-x: -#{@x}px; background-position-y: -#{@y}px; }"

  toggleVisibility: ->
    if @el().is('.visible')
      @display = 'hidden'
      @el().removeClass('visible').addClass('hidden')
    else
      @display = 'visible'
      @el().removeClass('hidden').addClass('visible')

module.exports = Tile
