Model = require 'activer'
Layer = require './layer.coffee'
Cell = require './cell.coffee'
Scene = require './scene.coffee'

class Chunk extends Model
  @belongsTo('Layer')
  @belongsTo('Scene')
  @hasMany('Cell')
  @attributes('col', 'row', 'dirty', 'cropped', 'width', 'height')

  @SIZE_IN_CELLS: 10

  heightInPx: ->
    @height * @game().tileSize

  widthInPx: ->
    @width * @game().tileSize

  toJSON: ->
    res = super()
    res.cells = @cells().forEach((cell) -> cell.toJSON())
    res

  clear: ->
    @context().clearRect(0, 0, @widthInPx(), @heightInPx())

  game: ->
    if @scene() then @scene().game() else @layer().game()

  afterCreate: ->
    @dirty = @dirty or false
    @canvas = document.createElement('canvas')
    @canvas.width = @widthInPx()
    @canvas.height = @heightInPx()
    @queue = []

  context: ->
    @canvas.getContext('2d')

  # called only for scene chunks
  # layer chunks will be off-screen
  render: (el) ->
    @canvas.style.top = @row * Chunk.SIZE_IN_CELLS * @game().tileSize + 'px'
    @canvas.style.left = @col * Chunk.SIZE_IN_CELLS * @game().tileSize + 'px'
    @canvas.setAttribute 'data-model-id', @id
    el.appendChild @canvas

module.exports = Chunk
