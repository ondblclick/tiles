$ = require 'jquery'

$.fn.contextMenu = (settings) ->
  getMenuPosition = (mouse, direction, scrollDir) ->
    win = $(window)[direction]()
    scroll = $(window)[scrollDir]()
    menu = $(settings.menuSelector)[direction]()
    position = mouse + scroll
    if mouse + menu > win and menu < mouse
      position -= menu
    position

  @each (args...) ->
    $(document).on 'contextmenu', settings.itemSelector, (e) ->
      return if e.ctrlKey

      that = this
      $menu = $(settings.menuSelector).show().css
        position: 'absolute'
        left: getMenuPosition(e.clientX, 'width', 'scrollLeft')
        top: getMenuPosition(e.clientY, 'height', 'scrollTop')

      $menu.off 'click'
      $menu.on 'click', 'a', (e) ->
        $menu.hide()
        $invokedOn = $(that)
        $selectedMenu = $(e.target)
        settings.menuSelected.call this, $invokedOn, $selectedMenu

      false

    $(document).on 'click', ->
      $(settings.menuSelector).hide()
