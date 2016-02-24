class @Editor extends Model
  hasMany: -> [Map]

  fields: ['tileSize', 'tileOffset', 'imagePath', 'tilesCols', 'tilesRows']

  initialize: ->
    @sprite = @_renderImage()
    @_createStyles()
    @_renderNavPanel()

  _createStyles: ->
    style = document.createElement('style')
    rules = ''
    for key, value of @_tilesSet()
      [x, y] = key.split('-')
      rules += "[data-tile-type='#{key}'] { background-position-x: -#{x}px; background-position-y: -#{y}px; }"
    rules += "[data-tile-type] { background-image: url('#{@imagePath}') }"
    style.appendChild(document.createTextNode(rules))
    document.head.appendChild(style)

  _renderImage: ->
    img = new Image()
    img.src = @imagePath
    img.id = 'sprite'
    $('body').append(img)
    img.onload = => @maps()[0].render()
    img

  _tilesSet: ->
    # TODO: change to array
    tilesSet = {}
    [0..(@tilesCols - 1)].forEach (col) =>
      [0..(@tilesRows - 1)].forEach (row) =>
        tilesSet["#{@_posToPix(col)}-#{@_posToPix(row)}"] = {}
    tilesSet

  _renderNavPanel: ->
    template = $.templates('#tile-library-modal')
    $('.list-tiles').append(template.render({ data: @_tilesSet() }))

  _posToPix: (pos) -> pos * (@tileSize + @tileOffset) + @tileOffset
