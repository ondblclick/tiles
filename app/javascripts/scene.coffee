Model = require 'activer'
Game = require './game.coffee'
Layer = require './layer.coffee'
Chunk = require './chunk.coffee'
utils = require './utils.coffee'

tabTmpl = require '../templates/scene_tab.hbs'
containerTmpl = require '../templates/scene_container.hbs'

class Scene extends Model
  @attributes('name', 'width', 'height', 'chunkSize')
  @belongsTo('Game')
  @hasMany('Layer', { dependent: 'destroy' })
  @hasMany('Chunk', { dependent: 'destroy' })
  @delegate('editor', 'Game')

  generateChunks: ->
    fullW = Math.floor(@width * @game().tileSize / @chunkSize)
    fullH = Math.floor(@height * @game().tileSize / @chunkSize)
    partialW = @width * @game().tileSize % @chunkSize
    partialH = @height * @game().tileSize % @chunkSize

    [0..(fullW - 1)].forEach (col) =>
      [0..(fullH - 1)].forEach (row) =>
        @chunks().create({ col: col, row: row, dirty: true, height: @chunkSize, width: @chunkSize })

    [0..(fullW - 1)].forEach (col) =>
      @chunks().create({ col: col, row: fullH, dirty: true, width: @chunkSize, height: partialH })

    [0..(fullH - 1)].forEach (row) =>
      @chunks().create({ col: fullW, row: row, dirty: true, width: partialW, height: @chunkSize })

    @chunks().create({ col: fullW, row: fullH, dirty: true, width: partialW, height: partialH })

  afterCreate: ->
    @chunkSize = @game().tileSize * 10
    @debouncedRender = utils.debounce(@renderVisibleChunks, 150)
    @generateChunks()

  visibleChunks: ->
    # something wrong here
    w = $("#scene-containers > li[data-model-id='#{@id}'] .canvas-container")[0]
    res = @chunks().filter (chunk) =>
      cond1 = chunk.col >= Math.floor(w.scrollLeft / @chunkSize)
      cond2 = chunk.col < Math.ceil((w.scrollLeft + 1000) / @chunkSize)
      cond3 = chunk.row >= Math.floor(w.scrollTop / @chunkSize)
      cond4 = chunk.row < Math.ceil((w.scrollTop + 1000) / @chunkSize)
      cond1 and cond2 and cond3 and cond4
    res

  sortedLayers: ->
    @layers().sort (layerA, layerB) ->
      +layerA.order > +layerB.order

  renderVisibleChunks: =>
    @render()

  render: (c) ->
    console.time 'scene render'
    chunks = if c then [c] else @visibleChunks().filter((c) -> c.dirty is true)
    chunks.forEach (chunk) -> chunk.clear()
    chunks.forEach (chunk) =>
      chunk.dirty = false
      @sortedLayers().forEach (layer) ->
        layerChunk = layer.chunks().where({ col: chunk.col, row: chunk.row })[0]
        chunk.canvas.getContext('2d').drawImage(layerChunk.canvas, 0, 0, chunk.width, chunk.height)
    console.timeEnd 'scene render'

  toJSON: ->
    res = super()
    res.layers = @sortedLayers().map((layer) -> layer.toJSON())
    res

  renderToEditor: ->
    obj = @toJSON()
    obj.width *= @game().tileSize
    obj.height *= @game().tileSize
    obj.tileSize = @game().tileSize
    obj.tileSizeX2 = @game().tileSize * 2
    $('#scene-tabs').append(tabTmpl(@toJSON()))
    $('#scene-containers').append(containerTmpl(obj))
    @chunks().forEach (chunk) =>
      chunk.render($("#scene-containers > li[data-model-id='#{@id}'] .canvas-container .wrapper")[0])

    @sortedLayers().forEach (layer) -> layer.renderToEditor()
    $("#scene-containers > li[data-model-id='#{@id}'] .layers-list > .nav-item").first().addClass('active')
    @render()
    $("#scene-containers > li[data-model-id='#{@id}'] .canvas-container").on 'scroll', @debouncedRender

  removeFromEditor: ->
    $("#scene-containers li[data-model-id='#{@id}']").remove()
    $("#scene-tabs .nav-item[data-model-id='#{@id}']").remove()

  remove: ->
    @removeFromEditor()
    @destroy()

  updateAttributes: (attrs) =>
    cellsShouldBeUpdated = false

    if attrs.width and +@width isnt +attrs.width or attrs.height and +@height isnt +attrs.height
      cellsShouldBeUpdated = true

    for k, v of attrs
      @[k] = v if k in @constructor.fields

    if cellsShouldBeUpdated
      @layers().forEach (layer) -> layer.updateCellsList()

    @removeFromEditor()
    @renderToEditor()

module.exports = Scene
