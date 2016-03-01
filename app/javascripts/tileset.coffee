class @TileSet extends Model
  belongsTo: -> [Editor]
  fields: ['imagePath', 'cols', 'rows', 'uniqId', 'tileOffset']

  initialize: ->
    @tileSize = @editor().tileSize

  image: ->
    $("img##{@uniqId}")[0]

  renderStyles: ->
    style = document.createElement('style')
    style.id = @uniqId
    t = "[data-tile-id][data-tileset-id='#{@uniqId}'] {
      background-image: url('#{@imagePath}');
      width: #{@tileSize}px;
      height: #{@tileSize}px; }"
    for item in @tileIds()
      [x, y] = item.split('-')
      t += "[data-tile-id='#{item}'][data-tileset-id='#{@uniqId}'] {
        background-position-x: -#{x}px;
        background-position-y: -#{y}px; }"
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
