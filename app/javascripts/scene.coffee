Model = require 'activer'
Game = require './game.coffee'
Layer = require './layer.coffee'
Chunk = require './chunk.coffee'
utils = require './utils.coffee'

tabTmpl = require '../templates/scene_tab.hbs'
containerTmpl = require '../templates/scene_container.hbs'

class Scene extends Model
  @attributes('name', 'width', 'height')
  @belongsTo('Game')
  @hasMany('Layer', { dependent: 'destroy' })
  @hasMany('Chunk', { dependent: 'destroy' })
  @delegate('editor', 'Game')

  generateChunks: ->
    w = Math.ceil(@width / Chunk.SIZE_IN_CELLS)
    h = Math.ceil(@height / Chunk.SIZE_IN_CELLS)

    fullW = Math.floor(@width / Chunk.SIZE_IN_CELLS)
    fullH = Math.floor(@height / Chunk.SIZE_IN_CELLS)

    partialW = @width % Chunk.SIZE_IN_CELLS
    partialH = @height % Chunk.SIZE_IN_CELLS

    if w and h
      [1..w].forEach (col) =>
        [1..h].forEach (row) =>
          return if @chunks().where({ col: col - 1, row: row - 1 })[0]
          width = if col > fullW then partialW else Chunk.SIZE_IN_CELLS
          height = if row > fullH then partialH else Chunk.SIZE_IN_CELLS
          @chunks().create
            col: col - 1
            row: row - 1
            dirty: true
            height: height
            width: width

  afterCreate: ->
    @debouncedRender = utils.debounce(@renderVisibleChunks, 150)
    @generateChunks()

  visibleChunks: ->
    # something wrong here
    w = $("#scene-containers > li[data-model-id='#{@id}'] .canvas-container")[0]
    res = @chunks().filter (chunk) ->
      cond1 = chunk.col >= Math.floor(w.scrollLeft / chunk.widthInPx())
      cond2 = chunk.col < Math.ceil((w.scrollLeft + 1000) / chunk.widthInPx())
      cond3 = chunk.row >= Math.floor(w.scrollTop / chunk.heightInPx())
      cond4 = chunk.row < Math.ceil((w.scrollTop + 1000) / chunk.heightInPx())
      cond1 and cond2 and cond3 and cond4
    res

  sortedLayers: ->
    @layers().sort (layerA, layerB) ->
      +layerA.order > +layerB.order

  renderVisibleChunks: =>
    @render()

  render: (c) ->
    # console.time 'scene render'
    chunks = if c then [c] else @visibleChunks().filter((c) -> c.dirty is true)
    chunks.forEach (chunk) -> chunk.clear()
    chunks.forEach (chunk) =>
      chunk.dirty = false
      @sortedLayers().forEach (layer) ->
        layerChunk = layer.chunks().where({ col: chunk.col, row: chunk.row })[0]
        utils.canvas.drawChunk(chunk.context(), layerChunk.canvas, chunk)
    console.timeEnd 'scene render'

  toJSON: ->
    res = super()
    res.layers = @sortedLayers().map((layer) -> layer.toJSON())
    res

  renderToEditor: ->
    tabObj = @toJSON()
    tabObj.activeClass = if @editor().activeScene() is @ then 'active' else ''
    containerObj = @toJSON()
    containerObj.width *= @game().tileSize
    containerObj.height *= @game().tileSize
    containerObj.tileSize = @game().tileSize
    containerObj.tileSizeX2 = @game().tileSize * 2
    containerObj.activeClass = if @editor().activeScene() is @ then 'active' else ''
    $('#scene-tabs').append(tabTmpl(tabObj))
    $('#scene-containers').append(containerTmpl(containerObj))

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

  # TODO: move update attributes to activer
  # and make user be able to use before_update, after_update callbacks
  updateAttributes: (attrs) =>
    cellsShouldBeUpdated = false

    if attrs.width and +@width isnt +attrs.width or attrs.height and +@height isnt +attrs.height
      cellsShouldBeUpdated = true

    for k, v of attrs
      @[k] = v if k in @constructor.fields

    if cellsShouldBeUpdated
      # chunks should be updated
      @chunks().deleteAll()
      @generateChunks()

      # cells should be updated
      @layers().forEach (layer) -> layer.updateChunks()

    @removeFromEditor()
    @renderToEditor()

module.exports = Scene
