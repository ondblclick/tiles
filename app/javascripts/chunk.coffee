Model = require 'activer'
Layer = require './layer.coffee'
Cell = require './cell.coffee'
Scene = require './scene.coffee'

class Chunk extends Model
  @belongsTo('Layer')
  @belongsTo('Scene')
  @hasMany('Cell')
  @attributes('col', 'row', 'dirty')

  game: ->
    if @scene() then @scene().game() else @layer().game()

  afterCreate: ->
    @dirty = false
    @canvas = document.createElement('canvas')
    @canvas.width = if @scene() then @scene().chunkSize else @layer().scene().chunkSize
    @canvas.height = if @scene() then @scene().chunkSize else @layer().scene().chunkSize

  context: ->
    @canvas.getContext('2d')

  # called only for scene chunks
  # layer chunks will be off-screen
  render: (el) ->
    @canvas.style.top = @row * @scene().chunkSize + 'px'
    @canvas.style.left = @col * @scene().chunkSize + 'px'
    @canvas.setAttribute 'data-model-id', @id
    el.appendChild @canvas

module.exports = Chunk
