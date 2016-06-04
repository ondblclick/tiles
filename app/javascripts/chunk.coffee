Model = require 'activer'
Layer = require './layer.coffee'
Cell = require './cell.coffee'
Scene = require './scene.coffee'

class Chunk extends Model
  @belongsTo('Layer')
  @belongsTo('Scene')
  @hasMany('Cell', { dependent: 'destroy' })
  @attributes('col', 'row', 'dirty', 'cropped', 'width', 'height')

  @SIZE_IN_CELLS: 10

  @createChunksFor: (instance, scene) ->
    w = Math.ceil(scene.width / Chunk.SIZE_IN_CELLS)
    h = Math.ceil(scene.height / Chunk.SIZE_IN_CELLS)

    fullW = Math.floor(scene.width / Chunk.SIZE_IN_CELLS)
    fullH = Math.floor(scene.height / Chunk.SIZE_IN_CELLS)

    partialW = scene.width % Chunk.SIZE_IN_CELLS
    partialH = scene.height % Chunk.SIZE_IN_CELLS

    # optimization
    chunks = instance.chunks()

    if w and h
      [1..w].forEach (col) ->
        [1..h].forEach (row) ->
          return if chunks.where({ col: col - 1, row: row - 1 })[0]
          width = if col > fullW then partialW else Chunk.SIZE_IN_CELLS
          height = if row > fullH then partialH else Chunk.SIZE_IN_CELLS
          chunks.create
            col: col - 1
            row: row - 1
            dirty: true
            height: height
            width: width
            cropped: height isnt Chunk.SIZE_IN_CELLS or width isnt Chunk.SIZE_IN_CELLS

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
