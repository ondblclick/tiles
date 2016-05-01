Model = require 'activer'
Game = require './game.coffee'
Tile = require './tile.coffee'
Floor = require './floor.coffee'
$ = require 'jquery'
require('jsrender')($)

class Editor extends Model
  @attributes()
  @hasOne('Game')

  afterCreate: ->
    @bindings()
    @tile = undefined

  render: ->
    imagePromises = @game().tileSets().forEach (tileSet) -> tileSet.renderToEditor()
    $('#tilesets-tabs > li:first-child').addClass('is-active')
    $('#tilesets-containers > li:first-child').addClass('is-active')
    $.when(imagePromises...).then =>
      @renderScenes()

  renderScenes: ->
    @game().scenes().forEach (scene) -> scene.renderToEditor()
    $('#scene-tabs > li:first-child').addClass('is-active')
    $('#scene-containers > li:first-child').addClass('is-active')

  bindings: ->
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
      # existingTile = Tile.findByPosition({ x: currentX, y: currentY })
      # existingTile.destroy() if existingTile
      # @currentLayer().tiles().create
      #   x: currentX
      #   y: currentY
      #   uniqId: @selectedTile().data('tile-id')
      #   tileSetId: @selectedSet().id
      # @currentLayer().render()

    $(document).on 'mouseout', (e) =>
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
      floor.context().drawImage(@tile.tileSet().img, @tile.x, @tile.y, @game().tileSize, @game().tileSize, pageX * @game().tileSize, pageY * @game().tileSize, @game().tileSize, @game().tileSize)
      floor.context().globalAlpha = 1

module.exports = Editor
