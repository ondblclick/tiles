class @Editor extends Model
  hasMany: -> [Map]

  fields: ['tileSize', 'tileOffset', 'imagePath']

  initialize: ->
    @_renderImage()
    @_renderNavPanel()

  _renderImage: ->
    img = new Image()
    img.src = @imagePath
    img.id = 'sprite'
    $('body').append(img)
    img.onload = => @maps()[0].render()

  _renderNavPanel: ->
    template = $.templates('#tile-library-modal')
    $('.list-tiles').append(template.render({ data: tilesSet }))
