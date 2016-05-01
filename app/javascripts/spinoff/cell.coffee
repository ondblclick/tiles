Model = require 'activer'
Floor = require './floor.coffee'
Terrain = require './terrain.coffee'
$ = require 'jquery'

class Cell extends Model
  @belongsTo('Floor')
  @hasOne('Terrain')
  @attributes('col', 'row')

  render: ->
    @terrain().render() if @terrain()

module.exports = Cell
