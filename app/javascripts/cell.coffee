Model = require 'activer'
Layer = require './layer.coffee'
Terrain = require './terrain.coffee'

class Cell extends Model
  @belongsTo('Layer')
  @hasOne('Terrain')
  @attributes('col', 'row')
  @delegate('game', 'Layer')

  toJSON: ->
    res = super()
    res.terrain = @terrain().toJSON() if @terrain()
    res

  render: ->
    # return false
    # TODO: allow nil
    @terrain().render() if @terrain()

module.exports = Cell
