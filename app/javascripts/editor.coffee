Tile = require './tile.coffee'
Layer = require './layer.coffee'
Scene = require './scene.coffee'
EditorImporter = require './editor/editor_importer.coffee'
EditorExporter = require './editor/editor_exporter.coffee'
EditorAdder = require './editor/editor_adder.coffee'
EditorContexter = require './editor/editor_contexter.coffee'
EditorScroller = require './editor/editor_scroller.coffee'
utils = require './utils.coffee'

class Editor
  @KEY_PRESS_CALLBACKS: {
    32: {
      down: -> $('body').addClass('space-pressed')
      up: -> $('body').removeClass('space-pressed')
    }
  }

  constructor: (@game) ->
    @keysPressed = {}
    @bindings()
    new EditorImporter(@)
    new EditorExporter(@)
    new EditorContexter(@)
    new EditorAdder(@)
    new EditorScroller(@)
    @selectedTile = undefined

  keyPressed: (keyCode) ->
    @keysPressed[keyCode]

  tileSets: ->
    @game.tileSets()

  scenes: ->
    @game.scenes()

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
    @game.toJSON()

  toolIsSelected: (tool) ->
    $("#toolbar ##{tool}").is(':checked')

  bindings: ->
    $(document).on 'keydown', (e) =>
      e.preventDefault() if Editor.KEY_PRESS_CALLBACKS[e.keyCode]
      @keysPressed[e.keyCode] = true
      Editor.KEY_PRESS_CALLBACKS[e.keyCode].down() if Editor.KEY_PRESS_CALLBACKS[e.keyCode].down

    $(document).on 'keyup', (e) =>
      e.preventDefault() if Editor.KEY_PRESS_CALLBACKS[e.keyCode]
      @keysPressed[e.keyCode] = false
      Editor.KEY_PRESS_CALLBACKS[e.keyCode].up() if Editor.KEY_PRESS_CALLBACKS[e.keyCode].up

    $(document).on 'click', '.layers-list span', (e) =>
      $a = $(e.target).parents('.nav-item')
      if ($(e.target).next().length) then utils.swap($a, $a.prev()) else utils.swap($a, $a.next())

      $(e.target).parents('.layers-list').find('.nav-item').each (index, item) ->
        Layer.find($(item).data('model-id')).order = index

      console.time 'scene sorting'
      @activeScene().chunks().forEach (chunk) ->
        chunk.dirty = true
        chunk.save()
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
      return if @keyPressed(32)
      return unless @toolIsSelected('fill')

      # still the most lagging thing in the app =\
      console.time('floodfill')

      # HACK: using context.createPattern here to speed up rendering process
      buffer = utils.canvas.create(@game.tileSize, @game.tileSize)
      ctx = buffer.getContext('2d')
      ctx.drawImage(
        @selectedTile.tileSet().img,
        @selectedTile.x,
        @selectedTile.y,
        @game.tileSize,
        @game.tileSize,
        0,
        0,
        @game.tileSize,
        @game.tileSize
      )

      @activeLayer().chunks().forEach (chunk) =>
        chunk.jobs().deleteAll()
        chunk.jobs().create
          type: 'floodfill'
          params:
            tile: @selectedTile
            buffer: buffer
        utils.canvas.fill(chunk.context(), buffer)

      @activeScene().chunks().forEach (chunk) ->
        chunk.dirty = true
        chunk.save()

      @activeScene().render()
      console.timeEnd('floodfill')

    $(document).on 'click', 'canvas', (e) =>
      return if @keyPressed(32)
      return unless @toolIsSelected('remove')
      currentX = Math.floor(e.offsetX / @game.tileSize)
      currentY = Math.floor(e.offsetY / @game.tileSize)
      sceneChunk = @activeScene().chunks().find($(e.target).data('model-id'))
      layerChunk = @activeLayer().chunks().where({ col: sceneChunk.col, row: sceneChunk.row })[0]

      cell = layerChunk.cells().where({ col: currentX, row: currentY })[0]
      return unless cell
      cell.destroy()
      @activeScene().render(sceneChunk)

    $(document).on 'click', 'canvas', (e) =>
      return if @keyPressed(32)
      return unless @toolIsSelected('draw')
      return unless @selectedTile

      currentX = Math.floor(e.offsetX / @game.tileSize)
      currentY = Math.floor(e.offsetY / @game.tileSize)
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
      tileSize = @game.tileSize

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
