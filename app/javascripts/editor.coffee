Tile = require './tile.coffee'
Layer = require './layer.coffee'
Scene = require './scene.coffee'
TileSet = require './tileset.coffee'
Cell = require './cell.coffee'
Game = require './game.coffee'
Chunk = require './chunk.coffee'

EditorImporter = require './editor/editor_importer.coffee'
EditorExporter = require './editor/editor_exporter.coffee'
EditorAdder = require './editor/editor_adder.coffee'
EditorContexter = require './editor/editor_contexter.coffee'
EditorScroller = require './editor/editor_scroller.coffee'
EditorHistorian = require './editor/editor_historian.coffee'
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
    @menubarItems = [
      new EditorImporter(@)
      new EditorExporter(@)
      new EditorAdder(@)
    ]
    new EditorContexter(@)
    new EditorScroller(@)
    @historian = new EditorHistorian(@)
    @selectedTile = undefined

  import: (game) ->
    @game = game

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

  clear: ->
    $('#tileset-tabs').empty()
    $('#tileset-containers').empty()
    $('#scene-tabs').empty()
    $('#scene-containers').empty()
    $('#menubar').empty()
    $('.tileset-styles').remove()
    $('.tileset-images').remove()

  render: ->
    @clear()
    @menubarItems.forEach (instance) -> instance.appendMenu()
    imagePromises = @tileSets().forEach (tileSet) -> tileSet.renderToEditor()
    $('#tileset-tabs > .nav-item').first().addClass('active')
    $('#tileset-containers > li').first().addClass('active')
    $.when(imagePromises...).then =>
      # wat?
      setTimeout(=>
        @scenes().forEach (scene) -> scene.renderToEditor()
        $('#scene-tabs > .nav-item').first().addClass('active')
        $('#scene-containers > li').first().addClass('active')
      , 0)

  toJSON: ->
    TileSet: TileSet.dao()._collection.slice(0)
    Tile: Tile.dao()._collection.slice(0)
    Scene: Scene.dao()._collection.slice(0)
    Layer: Layer.dao()._collection.slice(0)
    Cell: Cell.dao()._collection.slice(0)
    Game: Game.dao()._collection.slice(0)

  toolIsSelected: (tool) ->
    $("#toolbar ##{tool}").is(':checked')

  bindings: ->
    $(document).on 'keydown', (e) =>
      e.preventDefault() if Editor.KEY_PRESS_CALLBACKS[e.keyCode]
      @keysPressed[e.keyCode] = true
      if Editor.KEY_PRESS_CALLBACKS[e.keyCode] and Editor.KEY_PRESS_CALLBACKS[e.keyCode].down
        Editor.KEY_PRESS_CALLBACKS[e.keyCode].down()

    $(document).on 'keyup', (e) =>
      e.preventDefault() if Editor.KEY_PRESS_CALLBACKS[e.keyCode]
      @keysPressed[e.keyCode] = false
      if Editor.KEY_PRESS_CALLBACKS[e.keyCode] and Editor.KEY_PRESS_CALLBACKS[e.keyCode].up
        Editor.KEY_PRESS_CALLBACKS[e.keyCode].up()

    $(document).on 'click', '.layers-list span', (e) =>
      $a = $(e.target).parents('.nav-item')
      if ($(e.target).next().length) then utils.swap($a, $a.prev()) else utils.swap($a, $a.next())

      $(e.target).parents('.layers-list').find('.nav-item').each (index, item) ->
        layer = Layer.find($(item).data('model-id'))
        layer.order = index
        layer.save()

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
      @historian.saveState('FLOODFILL')

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
      @historian.saveState('REMOVE')

      sceneChunk = @activeScene().chunks().find($(e.target).data('model-id'))
      layerChunk = @activeLayer().chunks().where({ col: sceneChunk.col, row: sceneChunk.row })[0]

      currentX = Math.floor(e.offsetX / @game.tileSize) + sceneChunk.col * Chunk.SIZE_IN_CELLS
      currentY = Math.floor(e.offsetY / @game.tileSize) + sceneChunk.row * Chunk.SIZE_IN_CELLS

      cell = layerChunk.layer().cells().where({ col: currentX, row: currentY })[0]
      return unless cell
      cell.destroy()
      @activeScene().render(sceneChunk)

    $(document).on 'click', 'canvas', (e) =>
      return if @keyPressed(32)
      return unless @toolIsSelected('draw')
      return unless @selectedTile
      @historian.saveState('DRAW')

      sceneChunk = @activeScene().chunks().find($(e.target).data('model-id'))
      layerChunk = @activeLayer().chunks().where({ col: sceneChunk.col, row: sceneChunk.row })[0]

      currentX = Math.floor(e.offsetX / @game.tileSize) + sceneChunk.col * Chunk.SIZE_IN_CELLS
      currentY = Math.floor(e.offsetY / @game.tileSize) + sceneChunk.row * Chunk.SIZE_IN_CELLS

      cell = layerChunk.layer().cells().where({ col: currentX, row: currentY })[0]
      cell.destroy() if cell
      cell = layerChunk.layer().cells().create({ col: currentX, row: currentY, tileId: @selectedTile.id })
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
