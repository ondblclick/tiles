Model = require 'activer'
Floor = require './floor.coffee'
$ = require 'jquery'

class Cell extends Model
  @belongsTo('Floor')
  @attributes('col', 'row')

module.exports = Cell
