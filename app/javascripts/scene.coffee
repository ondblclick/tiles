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

  createChunks: ->
    Chunk.createChunksFor(@, @)

  debouncedRender: =>
    utils.debounce(@renderVisibleChunks, 50)()

  afterCreate: ->
    @createChunks()

  visibleChunks: ->
    # TODO: should be refactored
    w = $("#scene-containers > li[data-model-id='#{@id}'] .canvas-container")[0]
    rect = w.getBoundingClientRect()
    width = if rect.width is 0 then 1000 else rect.width
    height = if rect.height is 0 then 1000 else rect.height

    # magic numbers
    res = @chunks().filter (chunk) =>
      cond1 = chunk.col * Chunk.SIZE_IN_CELLS * @game().tileSize < width + w.scrollLeft
      cond2 = chunk.col * Chunk.SIZE_IN_CELLS * @game().tileSize + chunk.widthInPx() > w.scrollLeft
      cond3 = chunk.row * Chunk.SIZE_IN_CELLS * @game().tileSize < height + w.scrollTop
      cond4 = chunk.row * Chunk.SIZE_IN_CELLS * @game().tileSize + chunk.heightInPx() > w.scrollTop
      cond1 and cond2 and cond3 and cond4
    res

  sortedLayers: ->
    @layers().sort (layerA, layerB) ->
      +layerA.order > +layerB.order

  renderVisibleChunks: =>
    @render()

  render: (c) ->
    unless @chunks().length
      @createChunks()
      @chunks().forEach (chunk) =>
        chunk.render($("#scene-containers > li[data-model-id='#{@id}'] .canvas-container .wrapper")[0])
      @layers().forEach (layer) ->
        layer.createChunks()
        layer.cells().forEach (cell) ->
          cell.render()

    chunks = if c then [c] else @visibleChunks().filter((chunk) -> chunk.dirty is true)
    chunks.forEach (chunk) -> chunk.clear()
    chunks.forEach (chunk) =>
      chunk.dirty = false
      chunk.save()

      @sortedLayers().forEach (layer) ->
        layerChunk = layer.chunks().where({ col: chunk.col, row: chunk.row })[0]

        # process floodfilling
        # (can be moved to background job)
        if layerChunk.jobs().length
          job = layerChunk.jobs()[0]
          layer.cells().deleteAll()
          cells = layer.cells()
          [0..9].forEach (col) ->
            [0..9].forEach (row) ->
              cells.create({ col: col, row: row, tileId: job.params.tile.id })
          utils.canvas.fill(layerChunk.context(), job.params.buffer)
          job.destroy()

        # draw layer to scene
        utils.canvas.drawChunk(chunk.context(), layerChunk.canvas, chunk)

  toJSON: ->
    res = super()
    res.layers = @sortedLayers().map((layer) -> layer.toJSON())
    res

  renderToEditor: ->
    tabObj = @toJSON()
    tabObj.activeClass = if editor.activeScene() is @ then 'active' else ''
    containerObj = @toJSON()
    containerObj.width *= @game().tileSize
    containerObj.height *= @game().tileSize
    containerObj.tileSize = @game().tileSize
    containerObj.tileSizeX2 = @game().tileSize * 2
    containerObj.activeClass = if editor.activeScene() is @ then 'active' else ''
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
      @createChunks()

      # cells should be updated
      @layers().forEach (layer) -> layer.updateChunks()

    @removeFromEditor()
    @renderToEditor()

module.exports = Scene
