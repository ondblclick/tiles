Model = require 'activer'
Game = require './game.coffee'
Tile = require './tile.coffee'
tabTmpl = require('../templates/tile_set_tab.hbs')
containerTmpl = require('../templates/tile_set_container.hbs')

class TileSet extends Model
  @attributes('name', 'imagePath', 'cols', 'rows', 'tileOffset', 'tileOpacityColor')
  @belongsTo('Game')
  @hasMany('Tile', { dependent: 'destroy' })

  afterCreate: ->
    @generateTiles()

  toJSON: ->
    res = super()
    res.tiles = @tiles().map((tile) -> tile.toJSON())
    res

  generateTiles: ->
    [0..(@cols - 1)].forEach (col) =>
      [0..(@rows - 1)].forEach (row) =>
        @tiles().create({ x: @posToPix(col), y: @posToPix(row), display: 'is-visible' })

  renderStyles: ->
    @style = document.createElement('style')
    @style.id = "style-#{@id}"
    t = ".tileset-container[data-model-id='#{@id}'] .tile {
      background-image: url('#{@imagePath}');
      width: #{@game().tileSize}px;
      height: #{@game().tileSize}px; }"
    t += @tiles().map((tile) -> tile.style()).join('')
    @style.appendChild(document.createTextNode(t))
    document.head.appendChild(@style)

  posToPix: (pos) -> pos * (@game().tileSize + +@tileOffset) + +@tileOffset

  renderImage: ->
    d = new $.Deferred
    @img = new Image()
    @img.src = @imagePath
    @img.id = "image-#{@id}"
    @img.style = 'display: none;'
    @img.onload = -> d.resolve()
    $('body').append(@img)
    d.promise()

  renderToEditor: ->
    obj = @toJSON()
    obj.tiles = @tiles().map((tile) -> tile.toJSON())
    $('#tileset-tabs').append(tabTmpl(@toJSON()))
    $('#tileset-containers').append(containerTmpl(obj))
    @renderStyles()
    @renderImage()

  removeFromEditor: ->
    $(@img).remove()
    $(@style).remove()
    $("#tileset-containers li[data-model-id='#{@id}']").remove()
    $("#tileset-tabs .nav-item[data-model-id='#{@id}']").remove()

  remove: ->
    @removeFromEditor()
    @destroy()

module.exports = TileSet
