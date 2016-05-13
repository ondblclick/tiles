Model = require 'activer'
Game = require './game.coffee'
Tile = require './tile.coffee'
Floor = require './floor.coffee'
Scene = require './scene.coffee'
TileSet = require './tileset.coffee'
$ = require 'jquery'
prompty = require 'prompty'
require './contextmenu.coffee'
require('jsrender')($)

class Editor extends Model
  @attributes()
  @hasOne('Game')
  @delegate('tileSets', 'Game')
  @delegate('scenes', 'Game')

  afterCreate: ->
    @bindings()
    @tile = undefined

  activeLayer: ->
    Floor.find($('#scene-containers > .active .layers-list > .active').data('model-id'))

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
    $('.tile').contextMenu
      menuSelector: "#tile-context"
      menuSelected: (invoked, selected) ->
        Tile.find(invoked.data('model-id')).toggleVisibility()

    $('#tileset-tabs li').contextMenu
      menuSelector: "#tileset-tab-context"
      menuSelected: (invoked, selected) ->
        if selected.data('action') is 'remove'
          TileSet.find(invoked.data('model-id')).remove()

    $(".layers-list > li").contextMenu
      menuSelector: "#floor-tab-context"
      menuSelected: (invoked, selected) ->
        if selected.data('action') is 'remove'
          Floor.find(invoked.data('model-id')).remove()

    $('#scene-tabs li').contextMenu
      menuSelector: "#scene-pill-context"
      menuSelected: (invoked, selected) =>
        if selected.data('action') is 'remove'
          Scene.find(invoked.data('model-id')).remove()
        if selected.data('action') is 'edit'
          @editModalFor(Scene.find(invoked.data('model-id'))).modal('show')

  bindings: ->
    # $(document).on 'click', '#export-as-png', (e) =>
    #   $(e.currentTarget).attr('href', @currentLayer().canvas()[0].toDataURL('image/png'))

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

    $(document).on 'click', '#add-floor', (e) =>
      attrs = prompty([
        { field: 'name', label: 'Floor name:' }
      ])
      return unless attrs
      floor = @scenes().find($('#scene-tabs li.active').data('model-id')).floors().create(attrs)
      floor.renderToEditor()

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
      # floor = Floor.find($(e.target).parents('.floor-container').data('model-id'))
      floor = @activeLayer()
      cell = floor.cells().where({ col: currentX, row: currentY })[0]
      cell = floor.cells().create({ col: currentX, row: currentY }) unless cell
      cell.terrain().destroy() if cell.terrain()
      cell.createTerrain({ tileId: @tile.id })
      @activeScene().render()

    $(document).on 'mouseout', (e) =>
      return unless $(e.target).is('canvas')
      # floor = Floor.find($(e.target).parents('.floor-container').data('model-id'))
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
