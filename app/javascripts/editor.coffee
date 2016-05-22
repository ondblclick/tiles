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

  bindings: ->
    $(document).on 'click', '.layers-list span', (e) =>
      $a = $(e.target).parents('.nav-item')
      if ($(e.target).next().length) then utils.swap($a, $a.prev()) else utils.swap($a, $a.next())

      $(e.target).parents('.layers-list').find('.nav-item').each (index, item) ->
        Layer.find($(item).data('model-id')).order = index

      @activeScene().render()
      false

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
      return unless @tile
      currentX = Math.floor(e.offsetX / @game().tileSize)
      currentY = Math.floor(e.offsetY / @game().tileSize)
      cell = @activeLayer().cells().where({ col: currentX, row: currentY })[0]
      cell = @activeLayer().cells().create({ col: currentX, row: currentY }) unless cell
      cell.terrain().destroy() if cell.terrain()
      cell.createTerrain({ tileId: @tile.id })
      @activeScene().render()

    $(document).on 'mouseout', (e) =>
      return unless $(e.target).is('canvas')
      return unless @dummySquare
      @activeScene().reRenderSquare(@dummySquare)
      @dummySquare = undefined

    $(document).on 'mousemove', (e) =>
      return unless $(e.target).is('canvas')
      return unless @tile
      pageX = Math.floor(e.offsetX / @game().tileSize)
      pageY = Math.floor(e.offsetY / @game().tileSize)
      @activeScene().reRenderSquare(@dummySquare) if @dummySquare
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
