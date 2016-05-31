Model = require 'activer'
Game = require './game.coffee'
Tile = require './tile.coffee'
Layer = require './layer.coffee'
Scene = require './scene.coffee'
EditorImporter = require './editor/editor_importer.coffee'
EditorExporter = require './editor/editor_exporter.coffee'
EditorAdder = require './editor/editor_adder.coffee'
EditorContexter = require './editor/editor_contexter.coffee'
utils = require './utils.coffee'

class Editor extends Model
  @attributes()
  @hasOne('Game')
  @hasOne('EditorExporter')
  @hasOne('EditorImporter')
  @hasOne('EditorAdder')
  @hasOne('EditorContexter')
  @delegate('tileSets', 'Game')
  @delegate('scenes', 'Game')

  afterCreate: ->
    @bindings()
    @createEditorImporter()
    @createEditorExporter()
    @createEditorAdder()
    @createEditorContexter()
    @selectedTile = undefined
    @spacePressed = false
    @dragScroll = false
    @dragScrollStartX = 0
    @dragScrollStartY = 0

  toolbar: ->
    $('#toolbar')

  menubar: ->
    $('#menubar')

  activeLayer: ->
    Layer.find($('#scene-containers > .active .layers-list > .active').data('model-id'))

  activeScene: ->
    Scene.find($('#scene-tabs > .active').data('model-id'))

  render: ->
    imagePromises = @tileSets().forEach (tileSet) -> tileSet.renderToEditor()
    $('#tileset-tabs > .nav-item').first().addClass('active')
    $('#tileset-containers > li').first().addClass('active')
    $.when(imagePromises...).then =>
      @renderScenes()

  renderScenes: ->
    @scenes().forEach (scene) -> scene.renderToEditor()
    $('#scene-tabs > .nav-item').first().addClass('active')
    $('#scene-containers > li').first().addClass('active')

  toJSON: ->
    # TODO: toJSON -> asJSON (as it is in rails)
    # TODO: options: { root: true, only: [], except: [], methods: [], include: [] }
    res = super()
    res.game = @game().toJSON()
    res

  toolIsSelected: (tool) ->
    $("#toolbar ##{tool}").is(':checked')

  bindings: ->
    $(document).on 'mousedown', 'canvas', (e) =>
      return unless @spacePressed
      @dragScroll = true
      @dragScrollStartX = e.pageX
      @dragScrollStartY = e.pageY

    $(document).on 'mouseup', (e) =>
      return unless @dragScroll
      @dragScroll = false

    $(document).on 'mousemove', (e) =>
      return unless @dragScroll
      deltaX = e.pageX - @dragScrollStartX
      deltaY = e.pageY - @dragScrollStartY
      el = $('.tab-pane.active .canvas-container')
      el.scrollLeft(el.scrollLeft() - deltaX)
      el.scrollTop(el.scrollTop() - deltaY)
      @dragScrollStartX = e.pageX
      @dragScrollStartY = e.pageY

    $(document).on 'keydown', (e) =>
      if e.keyCode is 32
        @spacePressed = true
        e.preventDefault()

    $(document).on 'keyup', (e) =>
      @spacePressed = false if e.keyCode is 32

    $(document).on 'click', '.layers-list span', (e) =>
      $a = $(e.target).parents('.nav-item')
      if ($(e.target).next().length) then utils.swap($a, $a.prev()) else utils.swap($a, $a.next())

      $(e.target).parents('.layers-list').find('.nav-item').each (index, item) ->
        Layer.find($(item).data('model-id')).order = index

      console.time 'scene sorting'
      @activeScene().chunks().forEach (chunk) -> chunk.dirty = true
      @activeScene().render()
      console.timeEnd 'scene sorting'
      false

    $(document).on 'change', '#show-hidden-tiles', (e) ->
      $('#tileset-containers').toggleClass('show-hidden-tiles', $(e.target).is(':checked'))

    $(document).on 'click', '.tile', (e) =>
      if $(e.target).is('.is-active')
        $(e.target).removeClass('is-active')
        @selectedTile = undefined
      else
        $('.tile').removeClass('is-active')
        $(e.target).addClass('is-active')
        @selectedTile = Tile.find($(e.target).data('model-id'))

    $(document).on 'click', 'canvas', (e) =>
      return if @spacePressed
      return unless @toolIsSelected('fill')

      # still the most lagging thing in the app =\
      console.time('floodfill')

      # HACK: using context.createPattern here to speed up rendering process
      buffer = utils.canvas.create(@game().tileSize, @game().tileSize)
      ctx = buffer.getContext('2d')
      ctx.drawImage(
        @selectedTile.tileSet().img,
        @selectedTile.x,
        @selectedTile.y,
        @game().tileSize,
        @game().tileSize,
        0,
        0,
        @game().tileSize,
        @game().tileSize
      )

      @activeLayer().chunks().forEach (chunk) =>
        chunk.queue = []
        chunk.queue.push
          type: 'floodfill'
          params:
            tile: @selectedTile
            buffer: buffer
        utils.canvas.fill(chunk.context(), buffer)

      @activeScene().chunks().forEach (chunk) -> chunk.dirty = true
      @activeScene().render()
      console.timeEnd('floodfill')

    $(document).on 'click', 'canvas', (e) =>
      return if @spacePressed
      return unless @toolIsSelected('remove')
      currentX = Math.floor(e.offsetX / @game().tileSize)
      currentY = Math.floor(e.offsetY / @game().tileSize)
      sceneChunk = @activeScene().chunks().find($(e.target).data('model-id'))
      layerChunk = @activeLayer().chunks().where({ col: sceneChunk.col, row: sceneChunk.row })[0]

      cell = layerChunk.cells().where({ col: currentX, row: currentY })[0]
      return unless cell
      cell.destroy()
      @activeScene().render(sceneChunk)

    $(document).on 'click', 'canvas', (e) =>
      return if @spacePressed
      return unless @toolIsSelected('draw')
      return unless @selectedTile

      currentX = Math.floor(e.offsetX / @game().tileSize)
      currentY = Math.floor(e.offsetY / @game().tileSize)
      sceneChunk = @activeScene().chunks().find($(e.target).data('model-id'))
      layerChunk = @activeLayer().chunks().where({ col: sceneChunk.col, row: sceneChunk.row })[0]

      cell = layerChunk.cells().where({ col: currentX, row: currentY })[0]
      cell.destroy() if cell
      cell = layerChunk.cells().create({ col: currentX, row: currentY, tileId: @selectedTile.id })
      cell.render()
      @activeScene().render(sceneChunk)

    # can get rid of two handlers below
    $(document).on 'mouseout', (e) =>
      return unless $(e.target).is('canvas')
      return unless @selectedTile
      sceneChunk = @activeScene().chunks().find($(e.target).data('model-id'))
      @activeScene().render(sceneChunk)

    $(document).on 'mousemove', (e) =>
      tileSize = @game().tileSize

      # the second most lagging thing in the app =\
      return unless $(e.target).is('canvas')
      return unless @selectedTile
      currentX = Math.floor(e.offsetX / tileSize)
      currentY = Math.floor(e.offsetY / tileSize)
      sceneChunk = @activeScene().chunks().find($(e.target).data('model-id'))
      @activeScene().render(sceneChunk)
      sceneChunk.context().globalAlpha = 0.3
      sceneChunk.context().drawImage(
        @selectedTile.tileSet().img,
        @selectedTile.x,
        @selectedTile.y,
        tileSize,
        tileSize,
        currentX * tileSize,
        currentY * tileSize,
        tileSize,
        tileSize
      )
      sceneChunk.context().globalAlpha = 1

module.exports = Editor
