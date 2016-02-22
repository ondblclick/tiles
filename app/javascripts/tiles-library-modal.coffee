class @TilesLibraryModal
  constructor: (@allowedTypes, @tile) ->
    @_bindings()

  _bindings: ->
    $(document).off 'click', '.list-tiles-item a'
    $(document).on 'click', '.list-tiles-item a', (e) =>
      Tile.create
        x: @tile.x
        y: @tile.y
        type: $(e.currentTarget).data('tile-type')
      canvas.render()
      @hide()

  show: ->
    template = $.templates('#tile-library-modal')
    $('body').append(template.render({ data: @allowedTypes }))

  hide: ->
    $('.popover').remove()
