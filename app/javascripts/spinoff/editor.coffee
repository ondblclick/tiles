Model = require 'activer'
Game = require './game.coffee'
Tile = require './tile.coffee'
Floor = require './floor.coffee'
Scene = require './scene.coffee'
TileSet = require './tileset.coffee'
$ = require 'jquery'
prompty = require 'prompty'
require('jsrender')($)

# TODO: don't restrict the size of scenes - let's make them 100x100 by default
# ...or the way to change the scene size dynamically should be implemented

class Editor extends Model
  @attributes()
  @hasOne('Game')
  @delegate('tileSets', 'Game')
  @delegate('scenes', 'Game')

  afterCreate: ->
    @bindings()
    @tile = undefined

  render: ->
    imagePromises = @tileSets().forEach (tileSet) -> tileSet.renderToEditor()
    $('#tileset-tabs > li').first().addClass('active')
    $('#tileset-containers > li').first().addClass('active')
    $.when(imagePromises...).then =>
      @renderScenes()

  renderScenes: ->
    @scenes().forEach (scene) -> scene.renderToEditor()
    $('#scene-tabs > li').first().addClass('active')
    $('#scene-containers > div').first().addClass('active')

  toJSON: ->
    # TODO: toJSON -> asJSON (as it is in rails)
    # TODO: options: { root: true, only: [], except: [], methods: [], include: [] }
    res = super()
    res.game = @game().toJSON()
    res

  bindings: ->
    $(document).on 'click', '#export-to-json', (e) =>
      e.stopPropagation()
      $(e.target).find('.dropdown').toggleClass('is-active')
      $(e.target).find('textarea').val(JSON.stringify(@toJSON())).select()

    $(document).on 'click', '.tab-delete', (e) ->
      e.preventDefault()
      e.stopPropagation()
      sure = confirm('Are you sure you want to delete it?')
      return unless sure
      model = switch $(e.target).parents('.tab').data('model-name')
        when 'TileSet' then TileSet
        when 'Floor' then Floor
        when 'Scene' then Scene
      model.find($(e.target).parents('.tab').data('model-id')).remove()

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
      floor = @scenes().find($(e.target).parents('.scene-container').data('model-id')).floors().create(attrs)
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
      floor = Floor.find($(e.target).parents('.floor-container').data('model-id'))
      cell = floor.cells().where({ col: currentX, row: currentY })[0]
      cell = floor.cells().create({ col: currentX, row: currentY }) unless cell
      cell.terrain().destroy() if cell.terrain()
      cell.createTerrain({ tileId: @tile.id })
      floor.render()

    $(document).on 'mouseout', (e) ->
      return unless $(e.target).is('canvas')
      floor = Floor.find($(e.target).parents('.floor-container').data('model-id'))
      floor.render()

    $(document).on 'mousemove', (e) =>
      return unless $(e.target).is('canvas')
      return unless @tile
      floor = Floor.find($(e.target).parents('.floor-container').data('model-id'))
      pageX = Math.floor(e.offsetX / @game().tileSize)
      pageY = Math.floor(e.offsetY / @game().tileSize)
      floor.render()
      floor.context().fillStyle = Floor.STYLES.WHITE
      floor.drawRect(pageX * @game().tileSize, pageY * @game().tileSize)
      floor.context().globalAlpha = 0.3
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
      floor.context().drawImage(attrs...)
      floor.context().globalAlpha = 1

module.exports = Editor
