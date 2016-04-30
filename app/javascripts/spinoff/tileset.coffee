Model = require 'activer'
Game = require './game.coffee'
$ = require 'jquery'

class TileSet extends Model
  @attributes('name', 'imagePath', 'cols', 'rows', 'tileOffset')
  @belongsTo('Game')

  renderStyles: ->
    style = document.createElement('style')
    style.id = @id
    t = ".tileset-container[data-model-id='#{@id}'] [data-tile-id] {
      background-image: url('#{@imagePath}');
      width: #{@game().tileSize}px;
      height: #{@game().tileSize}px; }"
    for item in @tileIds()
      [x, y] = item.split('-')
      t += ".tileset-container[data-model-id='#{@id}'] [data-tile-id='#{item}'] {
        background-position-x: -#{x}px;
        background-position-y: -#{y}px; }"
    style.appendChild(document.createTextNode(t))
    document.head.appendChild(style)

  tileIds: ->
    ids = []
    [0..(@cols - 1)].forEach (col) =>
      [0..(@rows - 1)].forEach (row) =>
        ids.push("#{@posToPix(col)}-#{@posToPix(row)}")
    ids

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

  renderTiles: ->
    template = $.templates('#tile')
    $('.list-tiles').append(template.render({ data: @tileIds().map((item) => { id: "#{item}", tileSetId: @id }) }))

  renderToEditor: ->
    tabTmpl = $.templates('#tileset-tab')
    containerTmpl = $.templates('#tileset-container')
    tab = tabTmpl.render(@toJSON())
    obj = @toJSON()
    obj.tiles = @tileIds().map((id) => { id: id })
    container = containerTmpl.render(obj)
    $('#tilesets-tabs').append(tab)
    $('#tilesets-containers').append(container)
    @renderStyles()
#     @renderTiles()
    @renderImage()

module.exports = TileSet
