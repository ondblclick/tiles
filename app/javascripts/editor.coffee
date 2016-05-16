Model = require 'activer'
Game = require './game.coffee'
Tile = require './tile.coffee'
Layer = require './layer.coffee'
Scene = require './scene.coffee'
TileSet = require './tileset.coffee'
utils = require './utils.coffee'
ContextMenu = require './context_menu.coffee'
$ = require 'jquery'
prompty = require 'prompty'
require('jsrender')($)

class Editor extends Model
  @attributes()
  @hasOne('Game')
  @delegate('tileSets', 'Game')
  @delegate('scenes', 'Game')

  afterCreate: ->
    @bindings()
    @tile = undefined

  handleContextMenuFor: (e) ->
    res = { using: -> }
    unless e.ctrlKey
      e.preventDefault()
      res.using = (selector, callback) ->
        new ContextMenu(selector, $(e.currentTarget), callback).showAt(e.clientX, e.clientY)
    res

  activeLayer: ->
    Layer.find($('#scene-containers > .active .layers-list > .active').data('model-id'))

  activeScene: ->
    Scene.find($('#scene-tabs > .active').data('model-id'))

  render: ->
    imagePromises = @tileSets().forEach (tileSet) -> tileSet.renderToEditor()
    $('#tileset-tabs > li').first().addClass('active')
    $('#tileset-containers > li').first().addClass('active')
    $.when(imagePromises...).then =>
      @renderScenes()
      @bindContextMenus()

  renderScenes: ->
    @scenes().forEach (scene) -> scene.renderToEditor()
    $('#scene-tabs > li').first().addClass('active')
    $('#scene-containers > li').first().addClass('active')

  toJSON: ->
    # TODO: toJSON -> asJSON (as it is in rails)
    # TODO: options: { root: true, only: [], except: [], methods: [], include: [] }
    res = super()
    res.game = @game().toJSON()
    res

  editModalFor: (instance) ->
    $form = $('#edit-modal form')
    $form.empty()
    textFieldTmpl = $.templates('#text-field')
    instance.constructor.fields.forEach (field) ->
      $form.append(textFieldTmpl.render({ name: field, value: instance[field] }))
    $('#edit-modal').off 'click'
    $('#edit-modal button').on 'click', ->
      data = {}
      $form.serializeArray().map (x) -> data[x.name] = x.value
      instance.updateAttributes(data)
      $('#edit-modal').modal('hide')
    $('#edit-modal')

  bindContextMenus: ->
    $(document).on 'contextmenu', '.tile', (e) =>
      @handleContextMenuFor(e).using '#tile-context', (invoked, selected) ->
        Tile.find(invoked.data('model-id')).toggleVisibility()

    $(document).on 'contextmenu', '#tileset-tabs li', (e) =>
      @handleContextMenuFor(e).using "#tileset-tab-context", (invoked, selected) ->
        if selected.data('action') is 'remove'
          TileSet.find(invoked.data('model-id')).remove()

    $(document).on 'contextmenu', '.layers-list > li', (e) =>
      @handleContextMenuFor(e).using "#layer-tab-context", (invoked, selected) ->
        if selected.data('action') is 'remove'
          Layer.find(invoked.data('model-id')).remove()

    $(document).on 'contextmenu', '#scene-tabs li', (e) =>
      @handleContextMenuFor(e).using "#scene-pill-context", (invoked, selected) =>
        if selected.data('action') is 'remove'
          Scene.find(invoked.data('model-id')).remove()
        if selected.data('action') is 'edit'
          @editModalFor(Scene.find(invoked.data('model-id'))).modal('show')

  bindings: ->
    $(document).on 'click', '.layers-list span', (e) =>
      $li = $(e.target).parents('.layers-list li')
      if ($(e.target).next().length) then utils.swap($li, $li.prev()) else utils.swap($li, $li.next())

      $(e.target).parents('.layers-list').find('li').each (index, item) ->
        Layer.find($(item).data('model-id')).order = index

      @activeScene().render()

    $(document).on 'change', '#show-hidden-tiles', (e) ->
      if $(e.target).is(':checked')
        $('#tileset-containers').addClass('show-hidden-tiles')
      else
        $('#tileset-containers').removeClass('show-hidden-tiles')

    $(document).on 'click', '#export-as-json', (e) =>
      e.stopPropagation()
      $('#export-as-json-modal').find('textarea').val(JSON.stringify(@toJSON()))
      $('#export-as-json-modal').modal('show')

    $(document).on 'click', '#add-scene', (e) =>
      attrs = prompty([
        { field: 'name', label: 'Scene name:' }
        { field: 'width', label: 'Scene width:' }
        { field: 'height', label: 'Scene height:' }
      ])
      return unless attrs
      scene = @scenes().create(attrs)
      scene.renderToEditor()

    $(document).on 'click', '#add-layer', (e) =>
      attrs = prompty([
        { field: 'name', label: 'Layer name:' }
      ])
      return unless attrs
      layer = @activeScene().layers().create(attrs)
      layer.renderToEditor()

    $(document).on 'click', '#add-tileset', (e) =>
      attrs = prompty([
        { field: 'name', label: 'Tileset name:' }
        { field: 'imagePath', label: 'Tileset image url:' }
        { field: 'cols', label: 'Tileset image columns:' }
        { field: 'rows', label: 'Tileset image rows:' }
        { field: 'tileOffset', label: 'Tileset tile offset:' }
      ])
      return unless attrs
      tileSet = @tileSets().create(attrs)
      tileSet.renderToEditor()

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
      layer = @activeLayer()
      cell = layer.cells().where({ col: currentX, row: currentY })[0]
      cell = layer.cells().create({ col: currentX, row: currentY }) unless cell
      cell.terrain().destroy() if cell.terrain()
      cell.createTerrain({ tileId: @tile.id })
      @activeScene().render()

    $(document).on 'mouseout', (e) =>
      return unless $(e.target).is('canvas')
      @activeScene().render()

    $(document).on 'mousemove', (e) =>
      return unless $(e.target).is('canvas')
      return unless @tile
      scene = Scene.find($(e.target).parents('#scene-containers > li').data('model-id'))
      pageX = Math.floor(e.offsetX / @game().tileSize)
      pageY = Math.floor(e.offsetY / @game().tileSize)
      scene.render()
      scene.context().fillStyle = Scene.STYLES.WHITE
      scene.drawRect(pageX * @game().tileSize, pageY * @game().tileSize)
      scene.context().globalAlpha = 0.3
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
      scene.context().drawImage(attrs...)
      scene.context().globalAlpha = 1

module.exports = Editor
