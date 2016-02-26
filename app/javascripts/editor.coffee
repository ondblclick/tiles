class @TileSet extends Model
  belongsTo: -> [Editor]
  fields: ['imagePath', 'cols', 'rows', 'uniqId']

  initialize: ->
    @tileOffset = @editor().tileOffset
    @tileSize = @editor().tileSize

  image: ->
    $("img##{@uniqId}")[0]

  renderStyles: ->
    style = document.createElement('style')
    style.id = @uniqId
    t = "[data-tile-id][data-tileset-id='#{@uniqId}'] { background-image: url('#{@imagePath}'); width: #{@tileSize}px; height: #{@tileSize}px; }"
    for item in @tileIds()
      [x, y] = item.split('-')
      t += "[data-tile-id='#{item}'][data-tileset-id='#{@uniqId}'] { background-position-x: -#{x}px; background-position-y: -#{y}px; }"
    style.appendChild(document.createTextNode(t))
    document.head.appendChild(style)

  renderImage: ->
    img = new Image()
    img.src = @imagePath
    img.id = @uniqId
    $('body').append(img)

  renderTiles: ->
    template = $.templates('#tile-library-modal')
    $('.list-tiles').append(template.render({ data: @tileIds().map((item) => { id: "#{item}", tileSetId: @uniqId }) }))

  tileIds: ->
    ids = []
    [0..(@cols - 1)].forEach (col) =>
      [0..(@rows - 1)].forEach (row) =>
        ids.push("#{@posToPix(col)}-#{@posToPix(row)}")
    ids

  posToPix: (pos) -> pos * (@tileSize + @tileOffset) + @tileOffset


class @Editor extends Model
  hasMany: -> [Map, TileSet]
  fields: ['tileSize', 'tileOffset']

  initialize: ->
    @tileOffset = @tileOffset or 0
    @_bindings()

  render: (cb) ->
    $('canvas').remove()
    @tilesets().forEach (tileSet) ->
      tileSet.renderImage()
      tileSet.renderTiles()
      tileSet.renderStyles()

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

  # toJSON: ->
  #   res = {}
  #   res.tileSize = @tileSize
  #   res.tileOffset = @tileOffset
  #   res.imagePath = @imagePath
  #   res.tilesCols = @tilesCols
  #   res.tilesRows = @tilesRows
  #   res.maps = @maps().map (map) -> map.toJSON()
  #   res

  # _renderImages: (cb) ->
  #   sprites = []
  #   @tileSets.forEach (tileSet) ->
  #     img = new Image()
  #     img.src = tileSet.imagePath
  #     img.id = tileSet.id
  #     $('body').append(img)
  #     img.onload = -> cb() if cb
  #     sprites.push img
  #   sprites

  # _tilesSet: ->
  #   tilesSet = []
  #   [0..(@tilesCols - 1)].forEach (col) =>
  #     [0..(@tilesRows - 1)].forEach (row) =>
  #       tilesSet.push("#{@_posToPix(col)}-#{@_posToPix(row)}")
  #   tilesSet

  # _renderNavPanel: ->
  #   template = $.templates('#tile-library-modal')
  #   $('.list-tiles').empty().append(template.render({ data: @_tilesSet().map((item) -> { type: "#{item}" }) }))

  # _posToPix: (pos) -> pos * (@tileSize + @tileOffset) + @tileOffset
