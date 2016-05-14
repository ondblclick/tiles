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
      if data[i] == +color[0] and +data[i + 1] == +color[1] and data[i + 2] == +color[2]
        data[i + 3] = 0
      i += 4
    origin

  # smells like shit
  render: ->
    ctx = $('#buffer')[0].getContext('2d')

    attrs1 = [
      $('#img-buffer')[0],
      0,
      0,
      @game().tileSize,
      @game().tileSize,
      @cell().col * @game().tileSize,
      @cell().row * @game().tileSize,
      @game().tileSize,
      @game().tileSize
    ]

    attrs = [
      @tile().tileSet().img,
      @tile().x,
      @tile().y,
      @game().tileSize,
      @game().tileSize,
      0,
      0,
      @game().tileSize,
      @game().tileSize
    ]

    ctx.drawImage(attrs...)
    imgData = ctx.getImageData(0, 0, 48, 48)
    ctx.putImageData(@adjustImage(imgData), 0, 0)
    $('#img-buffer')[0].src = $('#buffer')[0].toDataURL('image/png')
    @cell().floor().scene().context().drawImage(attrs1...)

module.exports = Terrain
