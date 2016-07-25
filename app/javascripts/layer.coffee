Model = require 'activer'
Scene = require './scene.coffee'
Chunk = require './chunk.coffee'
utils = require './utils.coffee'

tabTmpl = require '../templates/layer_tab.hbs'

class Layer extends Model
  @attributes('name', 'order')
  @belongsTo('Scene')
  @hasMany('Chunk', { dependent: 'destroy' })
  @hasMany('Cell', { dependent: 'destroy' })
  @delegate('game', 'Scene')

  toJSON: ->
    res = super()
    res.chunks = @chunks().map((chunk) -> chunk.toJSON())
    res

  createChunks: ->
    Chunk.createChunksFor(@, @scene())

  afterCreate: ->
    @createChunks()

  renderToEditor: ->
    $("#scene-containers > li[data-model-id='#{@scene().id}'] .layers-list").append(tabTmpl(@toJSON()))

  removeFromEditor: ->
    $(".layers-list .nav-item[data-model-id='#{@id}']").remove()

  remove: ->
    @removeFromEditor()
    @destroy()

  # called in case scene size changes in order to keep cells collection up to date
  updateChunks: ->
    # проще создать пачку временных канвасов, слить на их изображения
    # удалить все чанки из лейера, создать чанки заново и перелить на них изображения, один за одним

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

    # 3. run createChunks method
    @createChunks()

    # 4. crop chunks if needed
    # TODO: cells should be removed here as well
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

      chunk.cropped = true
      utils.canvas.drawChunk(chunk.context(), temp, chunk)

module.exports = Layer
