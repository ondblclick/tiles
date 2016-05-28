Model = require 'activer'
Layer = require './layer.coffee'
Cell = require './cell.coffee'
Scene = require './scene.coffee'

class Chunk extends Model
  @belongsTo('Layer')
  @belongsTo('Scene')
  @hasMany('Cell')
  @attributes('col', 'row', 'dirty', 'width', 'height')

  toJSON: ->
    res = super()
    res.cells = @cells().forEach((cell) -> cell.toJSON())
    res

  clear: ->
    @context().clearRect(0, 0, @width, @height)

  game: ->
    if @scene() then @scene().game() else @layer().game()

  afterCreate: ->
    @dirty = @dirty or false
    @canvas = document.createElement('canvas')
    @canvas.width = @width
    @canvas.height = @height

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
