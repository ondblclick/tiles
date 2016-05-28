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
    fullW = Math.floor(@scene().width * @game().tileSize / @scene().chunkSize)
    fullH = Math.floor(@scene().height * @game().tileSize / @scene().chunkSize)
    partialW = @scene().width * @game().tileSize % @scene().chunkSize
    partialH = @scene().height * @game().tileSize % @scene().chunkSize

    [0..(fullW - 1)].forEach (col) =>
      [0..(fullH - 1)].forEach (row) =>
        @chunks().create({ col: col, row: row, dirty: true, height: @scene().chunkSize, width: @scene().chunkSize })

    [0..(fullW - 1)].forEach (col) =>
      @chunks().create({ col: col, row: fullH, dirty: true, width: @scene().chunkSize, height: partialH })

    [0..(fullH - 1)].forEach (row) =>
      @chunks().create({ col: fullW, row: row, dirty: true, width: partialW, height: @scene().chunkSize })

    @chunks().create({ col: fullW, row: fullH, dirty: true, width: partialW, height: partialH })

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
  # updateCellsList: ->
  #   @cells().forEach (cell) =>
  #     cell.remove() if cell.col > +@scene().width - 1
  #     cell.remove() if cell.row > +@scene().height - 1

module.exports = Layer
