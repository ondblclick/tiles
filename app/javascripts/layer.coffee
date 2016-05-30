Model = require 'activer'
Scene = require './scene.coffee'
Chunk = require './chunk.coffee'
utils = require './utils.coffee'

tabTmpl = require '../templates/layer_tab.hbs'

class Layer extends Model
  @attributes('name', 'order')
  @belongsTo('Scene')
  @hasMany('Chunk', { dependent: 'destroy' })
  @delegate('game', 'Scene')

  toJSON: ->
    res = super()
    res.chunks = @chunks().map((chunk) -> chunk.toJSON())
    res

  generateChunks: ->
    w = Math.ceil(@scene().width / Chunk.SIZE_IN_CELLS)
    h = Math.ceil(@scene().height / Chunk.SIZE_IN_CELLS)

    fullW = Math.floor(@scene().width / Chunk.SIZE_IN_CELLS)
    fullH = Math.floor(@scene().height / Chunk.SIZE_IN_CELLS)

    partialW = @scene().width % Chunk.SIZE_IN_CELLS
    partialH = @scene().height % Chunk.SIZE_IN_CELLS

    if w and h
      [1..w].forEach (col) =>
        [1..h].forEach (row) =>
          return if @chunks().where({ col: col - 1, row: row - 1 })[0]
          width = if col > fullW then partialW else Chunk.SIZE_IN_CELLS
          height = if row > fullH then partialH else Chunk.SIZE_IN_CELLS
          @chunks().create
            col: col - 1
            row: row - 1
            height: height
            width: width
            cropped: height isnt Chunk.SIZE_IN_CELLS or width isnt Chunk.SIZE_IN_CELLS

  afterCreate: ->
    @generateChunks()

  renderToEditor: ->
    $("#scene-containers > li[data-model-id='#{@scene().id}'] .layers-list").append(tabTmpl(@toJSON()))

  removeFromEditor: ->
    $(".layers-list .nav-item[data-model-id='#{@id}']").remove()

  remove: ->
    @removeFromEditor()
    @destroy()

  # called in case scene size changes in order to keep cells collection up to date
  updateChunks: ->
    maxChunkSize = Chunk.SIZE_IN_CELLS * @game().tileSize

    # 1. remove all chunks are off boundaries
    @chunks().forEach (chunk) =>
      chunk.destroy() if chunk.col * Chunk.SIZE_IN_CELLS > @scene().width
      chunk.destroy() if chunk.row * Chunk.SIZE_IN_CELLS > @scene().height

    # 2. check if there are cropped chunks and make them of full-size
    @chunks().where({ cropped: true }).forEach (chunk) ->
      chunk.cropped = false
      temp = utils.canvas.create(maxChunkSize, maxChunkSize)
      utils.canvas.drawChunk(temp.getContext('2d'), chunk.canvas, chunk)
      chunk.width = Chunk.SIZE_IN_CELLS
      chunk.height = Chunk.SIZE_IN_CELLS
      chunk.canvas = temp

    # 3. run generateChunks method
    @generateChunks()

    # 4. crop chunks if needed
    lastColumnWidth = @scene().width % Chunk.SIZE_IN_CELLS
    lastRowHeight = @scene().height % Chunk.SIZE_IN_CELLS
    return if lastColumnWidth is 0
    return if lastRowHeight is 0
    lastChunk = @chunks()[@chunks().length - 1]
    return unless lastChunk
    { col, row } = lastChunk

    # TODO: should be moved to chunk update attributes
    @chunks().forEach (chunk) =>
      return unless chunk.col is col or chunk.row is row
      temp = utils.canvas.create(maxChunkSize, maxChunkSize)
      utils.canvas.drawChunk(temp.getContext('2d'), chunk.canvas, chunk)

      if chunk.col is col
        chunk.width = lastColumnWidth
        chunk.canvas.width = chunk.width * @game().tileSize

      if chunk.row is row
        chunk.height = lastRowHeight
        chunk.canvas.height = chunk.height * @game().tileSize

      utils.canvas.drawChunk(chunk.context(), temp, chunk)

module.exports = Layer
