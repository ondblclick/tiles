Model = require 'activer'
Floor = require './floor.coffee'
Terrain = require './terrain.coffee'
$ = require 'jquery'

class Cell extends Model
  @belongsTo('Floor')
  @hasOne('Terrain')
  @attributes('col', 'row')
  @delegate('game', 'Floor')

  render: ->
    # TODO: allow nil
    @terrain().render() if @terrain()

module.exports = Cell
