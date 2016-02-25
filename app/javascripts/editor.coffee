class @Editor extends Model
  hasMany: -> [Map]
  fields: ['tileSize', 'tileOffset', 'imagePath', 'tilesCols', 'tilesRows']

  initialize: ->
    @_bindings()

  render: (cb) ->
    $('canvas').remove()
    @sprite = @_renderImage(cb)
    @_createStyles()
    @_renderNavPanel()

  _bindings: ->
    $(document).off 'click', '#create-map'
    $(document).on 'click', '#create-map', =>
      Tile.collection = []
      Map.collection = []
      @maps().create({ cols: $('#map-width').val(), rows: $('#map-height').val() })
      @maps()[0].prepareCanvas()
      @maps()[0].render()

    $(document).off 'click', '#export-as-png'
    $(document).on 'click', '#export-as-png', (e) =>
      $(e.currentTarget).attr('href', @maps()[0].canvas()[0].toDataURL('image/png'))

    $(document).off 'click', '.list-tiles-item'
    $(document).on 'click', '.list-tiles-item', (e) ->
      $(e.currentTarget).toggleClass('active').siblings().removeClass('active')

  toJSON: ->
    res = {}
    res.tileSize = @tileSize
    res.tileOffset = @tileOffset
    res.imagePath = @imagePath
    res.tilesCols = @tilesCols
    res.tilesRows = @tilesRows
    res.maps = @maps().map (map) -> map.toJSON()
    res

  _createStyles: ->
    $('#tiles-set').remove()
    style = document.createElement('style')
    style.id = 'tiles-set'
    rules = ''
    for item in @_tilesSet()
      [x, y] = item.split('-')
      rules += "[data-tile-type='#{item}'] { background-position-x: -#{x}px; background-position-y: -#{y}px; }"
    rules += "[data-tile-type] { background-image: url('#{@imagePath}') }"
    style.appendChild(document.createTextNode(rules))
    document.head.appendChild(style)

  _renderImage: (cb) ->
    img = new Image()
    img.src = @imagePath
    img.id = 'sprite'
    $('body').append(img)
    img.onload = -> cb() if cb
    img

  _tilesSet: ->
    tilesSet = []
    [0..(@tilesCols - 1)].forEach (col) =>
      [0..(@tilesRows - 1)].forEach (row) =>
        tilesSet.push("#{@_posToPix(col)}-#{@_posToPix(row)}")
    tilesSet

  _renderNavPanel: ->
    template = $.templates('#tile-library-modal')
    $('.list-tiles').empty().append(template.render({ data: @_tilesSet().map((item) -> { type: "#{item}" }) }))

  _posToPix: (pos) -> pos * (@tileSize + @tileOffset) + @tileOffset
