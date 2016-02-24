class @Editor extends Model
  hasMany: -> [Map]

  fields: ['tileSize', 'tileOffset', 'imagePath', 'tilesCols', 'tilesRows']

  initialize: ->
    @sprite = @_renderImage()
    @_renderNavPanel()

  _renderImage: ->
    img = new Image()
    img.src = @imagePath
    img.id = 'sprite'
    $('body').append(img)
    img.onload = => @maps()[0].render()
    img

  _tilesSet: ->
    tilesSet = {}
    [0..(@tilesCols - 1)].forEach (col) =>
      [0..(@tilesRows - 1)].forEach (row) ->
        tilesSet["#{col}-#{row}"] = {}
    tilesSet

  _renderNavPanel: ->
    template = $.templates('#tile-library-modal')
    $('.list-tiles').append(template.render({ data: @_tilesSet() }))
