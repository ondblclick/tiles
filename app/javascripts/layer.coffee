Model = require 'activer'
Scene = require './scene.coffee'
Chunk = require './chunk.coffee'

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
    fullW = Math.floor(@scene().width / Chunk.SIZE_IN_CELLS)
    fullH = Math.floor(@scene().height / Chunk.SIZE_IN_CELLS)
    partialW = @scene().width % Chunk.SIZE_IN_CELLS
    partialH = @scene().height % Chunk.SIZE_IN_CELLS

    [0..(fullW - 1)].forEach (col) =>
      [0..(fullH - 1)].forEach (row) =>
        return if @chunks().where({ col: col, row: row })[0]
        return if col < 0 or row < 0
        @chunks().create
          col: col
          row: row
          dirty: true
          height: Chunk.SIZE_IN_CELLS
          width: Chunk.SIZE_IN_CELLS
          cropped: false

    if partialH
      [0..(fullW - 1)].forEach (col) =>
        return if @chunks().where({ col: col, row: fullH })[0]
        return if col < 0
        @chunks().create
          col: col
          row: fullH
          dirty: true
          width: Chunk.SIZE_IN_CELLS
          height: partialH
          cropped: true

    if partialW
      [0..(fullH - 1)].forEach (row) =>
        return if @chunks().where({ col: fullW, row: row })[0]
        return if row < 0
        @chunks().create
          col: fullW
          row: row
          dirty: true
          width: partialW
          height: Chunk.SIZE_IN_CELLS
          cropped: true

    if partialH and partialW
      unless @chunks().where({ col: fullW, row: fullH })[0]
        @chunks().create
          col: fullW
          row: fullH
          dirty: true
          width: partialW
          height: partialH
          cropped: true

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

    # 1. remove all chunks are off boundaries
    @chunks().forEach (chunk) =>
      chunk.destroy() if chunk.col * Chunk.SIZE_IN_CELLS > @scene().width
      chunk.destroy() if chunk.row * Chunk.SIZE_IN_CELLS > @scene().height

    # 2. check if there are cropped chunks and make them of full-size
    @chunks().where({ cropped: true }).forEach (chunk) =>
      chunk.cropped = false

      # HACK: temp canvas magic
      temp = document.createElement('canvas')
      temp.width = Chunk.SIZE_IN_CELLS * @game().tileSize
      temp.height = Chunk.SIZE_IN_CELLS * @game().tileSize
      temp.getContext('2d').drawImage(
        chunk.canvas,
        0,
        0,
        chunk.width * @game().tileSize,
        chunk.height * @game().tileSize,
        0,
        0,
        chunk.width * @game().tileSize,
        chunk.height * @game().tileSize
      )

      chunk.width = Chunk.SIZE_IN_CELLS
      chunk.height = Chunk.SIZE_IN_CELLS
      chunk.context().drawImage(
        temp,
        0,
        0,
        Chunk.SIZE_IN_CELLS * @game().tileSize,
        Chunk.SIZE_IN_CELLS * @game().tileSize,
        0,
        0,
        Chunk.SIZE_IN_CELLS * @game().tileSize,
        Chunk.SIZE_IN_CELLS * @game().tileSize
      )

    # 3. run generateChunks method
    @generateChunks()

    # 4. crop chunks if needed
    lastColumnWidth = @scene().width % Chunk.SIZE_IN_CELLS
    lastRowHeight = @scene().height % Chunk.SIZE_IN_CELLS
    return if lastColumnWidth is 0
    return if lastRowHeight is 0
    { col, row } = @chunks()[@chunks().length - 1] # TODO: handle if no chunks

    # TODO: should be moved to chunk update attributes
    @chunks().where({ col: col }).forEach (chunk) =>

      # HACK: temp canvas magic
      temp = document.createElement('canvas')
      temp.width = Chunk.SIZE_IN_CELLS * @game().tileSize
      temp.height = Chunk.SIZE_IN_CELLS * @game().tileSize
      temp.getContext('2d').drawImage(
        chunk.canvas
        0,
        0,
        Chunk.SIZE_IN_CELLS * @game().tileSize,
        Chunk.SIZE_IN_CELLS * @game().tileSize,
        0,
        0,
        Chunk.SIZE_IN_CELLS * @game().tileSize,
        Chunk.SIZE_IN_CELLS * @game().tileSize
      )

      chunk.width = lastColumnWidth * @game().tileSize
      chunk.canvas.width = chunk.width
      chunk.context().drawImage(
        temp,
        0,
        0,
        chunk.widthInPx(),
        chunk.heightInPx(),
        0,
        0,
        chunk.widthInPx(),
        chunk.heightInPx()
      )

    @chunks().where({ row: row }).forEach (chunk) =>

      # HACK: temp canvas magic
      temp = document.createElement('canvas')
      temp.width = Chunk.SIZE_IN_CELLS * @game().tileSize
      temp.height = Chunk.SIZE_IN_CELLS * @game().tileSize
      temp.getContext('2d').drawImage(
        chunk.canvas
        0,
        0,
        Chunk.SIZE_IN_CELLS * @game().tileSize,
        Chunk.SIZE_IN_CELLS * @game().tileSize,
        0,
        0,
        Chunk.SIZE_IN_CELLS * @game().tileSize,
        Chunk.SIZE_IN_CELLS * @game().tileSize
      )

      chunk.height = lastRowHeight * @game().tileSize
      chunk.canvas.height = chunk.height
      chunk.context().drawImage(
        temp,
        0,
        0,
        chunk.widthInPx(),
        chunk.heightInPx(),
        0,
        0,
        chunk.widthInPx(),
        chunk.heightInPx()
      )

module.exports = Layer
