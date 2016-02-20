class @TilesLibraryModal
  constructor: (@allowedTypes, @tile) ->

  show: ->
    template = $.templates('#tile-library-modal')
    $('body').append(template.render({ data: @allowedTypes }))

  hide: ->
    $('.backdrop').remove()
