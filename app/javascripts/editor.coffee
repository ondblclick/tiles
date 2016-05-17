Model = require 'activer'
Game = require './game.coffee'
Tile = require './tile.coffee'
Layer = require './layer.coffee'
Scene = require './scene.coffee'
TileSet = require './tileset.coffee'
utils = require './utils.coffee'
ContextMenu = require './context_menu.coffee'
$ = require 'jquery'
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

  newModalFor: (attributes, onSubmit) ->
    $form = $('#new-modal form')
    $form.empty()
    textFieldTmpl = $.templates('#text-field')
    attributes.forEach (field) ->
      $form.append(textFieldTmpl.render({ name: field, value: '' }))
    $('#new-modal button').off 'click'
    $('#new-modal button').on 'click', ->
      data = {}
      $form.serializeArray().map (x) -> data[x.name] = x.value
      onSubmit(data)
      $('#new-modal').modal('hide')
    $('#new-modal').modal('show')

  editModalFor: (instance, onSubmit) ->
    $form = $('#edit-modal form')
    $form.empty()
    textFieldTmpl = $.templates('#text-field')
    ctor = instance.constructor
    ctor.fields.forEach (field) ->
      $form.append(textFieldTmpl.render({ name: field, value: instance[field] })) if field in ctor.WHITELISTED_FIELDS
    $('#edit-modal').off 'click'
    $('#edit-modal button').on 'click', ->
      data = {}
      $form.serializeArray().map (x) -> data[x.name] = x.value
      onSubmit(data)
      $('#edit-modal').modal('hide')
    $('#edit-modal').modal('show')

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
          instance = Scene.find(invoked.data('model-id'))
          @editModalFor(instance, instance.updateAttributes)

  bindings: ->
    $(document).on 'click', '.layers-list span', (e) =>
      $li = $(e.target).parents('.layers-list li')
      if ($(e.target).next().length) then utils.swap($li, $li.prev()) else utils.swap($li, $li.next())

      $(e.target).parents('.layers-list').find('li').each (index, item) ->
        Layer.find($(item).data('model-id')).order = index

      @activeScene().render()

    $(document).on 'change', '#show-hidden-tiles', (e) ->
      $('#tileset-containers').toggleClass('show-hidden-tiles', $(e.target).is(':checked'))

    $(document).on 'click', '#export-as-json', (e) =>
      e.stopPropagation()
      $('#export-as-json-modal').find('textarea').val(JSON.stringify(@toJSON()))
      $('#export-as-json-modal').modal('show')

    $(document).on 'click', '#add-scene', (e) =>
      @newModalFor ['name', 'width', 'height'], (data) =>
        scene = @scenes().create(data)
        scene.renderToEditor()

    $(document).on 'click', '#add-layer', (e) =>
      @newModalFor ['name'], (data) =>
        layer = @activeScene().layers().create(data)
        layer.renderToEditor()

    $(document).on 'click', '#add-tileset', (e) =>
      @newModalFor ['name', 'imagePath', 'cols', 'rows', 'tileOffset'], (data) =>
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
      cell = @activeLayer().cells().where({ col: currentX, row: currentY })[0]
      cell = @activeLayer().cells().create({ col: currentX, row: currentY }) unless cell
      cell.terrain().destroy() if cell.terrain()
      cell.createTerrain({ tileId: @tile.id })
      @activeScene().render()

    $(document).on 'mouseout', (e) =>
      return unless $(e.target).is('canvas')
      @activeScene().render()

    $(document).on 'mousemove', (e) =>
      return unless $(e.target).is('canvas')
      return unless @tile
      pageX = Math.floor(e.offsetX / @game().tileSize)
      pageY = Math.floor(e.offsetY / @game().tileSize)
      @activeScene().render()
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
      @activeScene().context().globalAlpha = 1

module.exports = Editor
