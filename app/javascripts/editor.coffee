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
    @tile = undefined
    @dummySquare = undefined

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
    $(document).on 'click', '.layers-list span', (e) =>
      $a = $(e.target).parents('.nav-item')
      if ($(e.target).next().length) then utils.swap($a, $a.prev()) else utils.swap($a, $a.next())

      $(e.target).parents('.layers-list').find('.nav-item').each (index, item) ->
        Layer.find($(item).data('model-id')).order = index

      # TODO: еще одно узкое место. нельзя просто рендерить целиком большие сцены со множеством слоев.
      # хранить кроме джисона еще и картинки, чтобы была возможность быстро стартовать?

      # возвращаемся к одному канвасу на слой?
      # изменения порядка будет приводить только к изменению взаиморасположения канвасов
      # и не нужно ничего вообще перерисовывать

      # избавится от понятия тиррейн и всю отрисовку переместить в целл?
      # Все же проблема быстрого старта останется нетронутой - первичный рендер будет занимать кучу времени

      console.time 'scene ordering'
      @activeScene().render()
      false
      console.timeEnd 'scene ordering'

    $(document).on 'change', '#show-hidden-tiles', (e) ->
      $('#tileset-containers').toggleClass('show-hidden-tiles', $(e.target).is(':checked'))

    $(document).on 'click', '.tile', (e) =>
      if $(e.target).is('.is-active')
        $(e.target).removeClass('is-active')
        @tile = undefined
      else
        $('.tile').removeClass('is-active')
        $(e.target).addClass('is-active')
        @tile = Tile.find($(e.target).data('model-id'))

    $(document).on 'click', 'canvas', (e) =>
      console.time('floodfill')
      return unless @toolIsSelected('fill')
      @activeLayer().cells().deleteAll()
      cells = @activeLayer().cells()
      [0..(@activeScene().width - 1)].forEach (col) =>
        [0..(@activeScene().height - 1)].forEach (row) =>
          cell = cells.create({ col: col, row: row, tileId: @tile.id })

      # HACK: using context.createPattern here to speed up rendering process
      ctx = $('#buffer')[0].getContext('2d')
      attrs = [
        @tile.tileSet().img,
        @tile.x,
        @tile.y,
        @game().tileSize,
        @game().tileSize,
        0,
        0,
        @game().tileSize,
        @game().tileSize
      ]
      ctx.drawImage(attrs...)
      pattern = @activeScene().context().createPattern($('#buffer')[0], 'repeat')
      @activeScene().context().rect(0, 0, @activeScene().canvas()[0].width, @activeScene().canvas()[0].height)
      @activeScene().context().fillStyle = pattern
      @activeScene().context().fill()
      console.timeEnd('floodfill')

    $(document).on 'click', 'canvas', (e) =>
      return unless @toolIsSelected('remove')
      currentX = Math.floor(e.offsetX / @game().tileSize)
      currentY = Math.floor(e.offsetY / @game().tileSize)
      cell = @activeLayer().cells().where({ col: currentX, row: currentY })[0]
      return unless cell
      cell.destroy()
      @activeScene().renderCell({ x: currentX, y: currentY })

    $(document).on 'click', 'canvas', (e) =>
      return unless @toolIsSelected('draw')
      return unless @tile
      currentX = Math.floor(e.offsetX / @game().tileSize)
      currentY = Math.floor(e.offsetY / @game().tileSize)
      cell = @activeLayer().cells().where({ col: currentX, row: currentY })[0]
      cell = @activeLayer().cells().create({ col: currentX, row: currentY, tileId: @tile.id }) unless cell
      @activeScene().renderCell({ x: currentX, y: currentY })

    $(document).on 'mouseout', (e) =>
      return unless $(e.target).is('canvas')
      return unless @dummySquare
      @activeScene().renderCell(@dummySquare)
      @dummySquare = undefined

    $(document).on 'mousemove', (e) =>
      return unless $(e.target).is('canvas')
      return unless @tile
      pageX = Math.floor(e.offsetX / @game().tileSize)
      pageY = Math.floor(e.offsetY / @game().tileSize)
      @activeScene().renderCell(@dummySquare) if @dummySquare
      @activeScene().context().fillStyle = Scene.STYLES.WHITE
      @activeScene().drawRect(pageX * @game().tileSize, pageY * @game().tileSize)
      @activeScene().context().globalAlpha = 0.3
      attrs = [
        @tile.tileSet().img,
        @tile.x,
        @tile.y,
        @game().tileSize,
        @game().tileSize,
        pageX * @game().tileSize,
        pageY * @game().tileSize,
        @game().tileSize,
        @game().tileSize
      ]
      @activeScene().context().drawImage(attrs...)
      @dummySquare = { x: pageX, y: pageY }
      @activeScene().context().globalAlpha = 1

module.exports = Editor
