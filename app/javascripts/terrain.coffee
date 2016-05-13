Model = require 'activer'
Cell = require './cell.coffee'
Tile = require './tile.coffee'
$ = require 'jquery'

class Terrain extends Model
  @belongsTo('Cell')
  @belongsTo('Tile')
  @delegate('game', 'Cell')

  adjustImage: (origin) ->
    color = @tile().tileSet().tileOpacityColor.split(',')
    data = origin.data
    i = 0
    while i < data.length
      data[i + 3] = 0 if (data[i] is color[0]) and (data[i + 1] is color[1]) and (data[i + 2] is color[2])
      i += 4
    origin

  render: ->
    ctx = $('#buffer')[0].getContext('2d')

    attrs = [
      @tile().tileSet().img,
      @tile().x,
      @tile().y,
      @game().tileSize,
      @game().tileSize,
      @cell().col * @game().tileSize,
      @cell().row * @game().tileSize,
      @game().tileSize,
      @game().tileSize
    ]

    ctx.drawImage(attrs...)
    imgData = ctx.getImageData(0, 0, 48, 48)
    @cell().floor().scene().context().putImageData(
      @adjustImage(imgData),
      @cell().col * @game().tileSize,
      @cell().row * @game().tileSize
    )

module.exports = Terrain
