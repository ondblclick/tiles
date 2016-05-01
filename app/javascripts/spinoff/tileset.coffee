Model = require 'activer'
Game = require './game.coffee'
Tile = require './tile.coffee'
$ = require 'jquery'

class TileSet extends Model
  @attributes('name', 'imagePath', 'cols', 'rows', 'tileOffset')
  @belongsTo('Game')
  @hasMany('Tile')

  afterCreate: ->
    @generateTiles()

  generateTiles: ->
    [0..(@cols - 1)].forEach (col) =>
      [0..(@rows - 1)].forEach (row) =>
        @tiles().create({ x: @posToPix(col), y: @posToPix(row) })

  renderStyles: ->
    style = document.createElement('style')
    style.id = @id
    t = ".tileset-container[data-model-id='#{@id}'] .tile {
      background-image: url('#{@imagePath}');
      width: #{@game().tileSize}px;
      height: #{@game().tileSize}px; }"
    t += @tiles().map((tile) -> tile.style()).join('')
    style.appendChild(document.createTextNode(t))
    document.head.appendChild(style)

  posToPix: (pos) -> pos * (@game().tileSize + @tileOffset) + @tileOffset

  renderImage: ->
    d = new $.Deferred
    img = new Image()
    img.src = @imagePath
    img.id = @id
    img.style = 'display: none;'
    img.onload = -> d.resolve()
    $('body').append(img)
    d.promise()

  renderToEditor: ->
    tabTmpl = $.templates('#tileset-tab')
    containerTmpl = $.templates('#tileset-container')
    tab = tabTmpl.render(@toJSON())
    obj = @toJSON()
    obj.tiles = @tiles().map((tile) => tile.toJSON())
    container = containerTmpl.render(obj)
    $('#tilesets-tabs').append(tab)
    $('#tilesets-containers').append(container)
    @renderStyles()
    @renderImage()

module.exports = TileSet
