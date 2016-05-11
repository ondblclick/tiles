Model = require 'activer'
Scene = require './scene.coffee'
Cell = require './cell.coffee'
$ = require 'jquery'

class Floor extends Model
  @attributes('name')
  @belongsTo('Scene')
  @hasMany('Cell', { dependent: 'destroy' })
  @delegate('game', 'Scene')

  @STYLES:
    GREY: 'rgba(0, 0, 0, .05)'
    WHITE: '#fff'

  toJSON: ->
    res = super()
    res.cells = @cells().map((cell) -> cell.toJSON())
    res

  canvas: -> $(".floor-container[data-model-id='#{@id}'] canvas")

  context: -> @canvas()[0].getContext('2d')

  render: ->
    @clear()
    @renderGrid()
    @renderTerrain()

  renderTerrain: ->
    @cells().map((cell) -> cell.render())

  clear: ->
    @context().fillStyle = Floor.STYLES.WHITE
    @context().fillRect(0, 0, @scene().width * @game().tileSize, @scene().height * @game().tileSize)

  renderToEditor: ->
    tabTmpl = $.templates('#floor-tab')
    containerTmpl = $.templates('#floor-container')
    tab = tabTmpl.render(@toJSON())
    obj = @toJSON()
    obj.width = @scene().width * @game().tileSize
    obj.height = @scene().height * @game().tileSize
    container = containerTmpl.render(obj)
    $("#floor-tabs-#{@sceneId}").append(tab)
    $("#floor-containers-#{@sceneId}").append(container)
    @renderGrid()
    @renderTerrain()

  removeFromEditor: ->
    $(".floor-containers li[data-model-id='#{@id}']").remove()
    $(".floor-tabs li[data-model-id='#{@id}']").remove()

  drawRect: (x, y) ->
    @context().fillRect(x, y, @game().tileSize, @game().tileSize)

  remove: ->
    @removeFromEditor()
    @destroy()

  renderGrid: ->
    @context().fillStyle = Floor.STYLES.GREY
    col = 0
    while col < @scene().width
      row = 0
      while row < @scene().height
        if (row % 2 is 0 and col % 2 is 1) or (row % 2 is 1 and col % 2 is 0)
          @drawRect(col * @game().tileSize, row * @game().tileSize)
        row++
      col++

  # called in case scene size changes in order to keep cells set up to date
  updateCellsList: ->
    @cells().forEach (cell) =>
      cell.remove() if cell.col > +@scene().width - 1
      cell.remove() if cell.row > +@scene().height - 1

module.exports = Floor
