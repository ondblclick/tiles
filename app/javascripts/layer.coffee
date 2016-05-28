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
    [0..(@scene().width * @game().tileSize / @scene().chunkSize - 1)].forEach (col) =>
      [0..(@scene().height * @game().tileSize / @scene().chunkSize - 1)].forEach (row) =>
        @chunks().create({ col: col, row: row, dirty: false })

  renderCell: ({ x, y }) ->
    @context().clearRect(
      x * @game().tileSize,
      y * @game().tileSize,
      @game().tileSize,
      @game().tileSize
    )
    cell = @cells().where({ col: x, row: y })[0]
    cell.render(@context()) if cell

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
