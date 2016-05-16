$ = require 'jquery'

class ContextMenu
  constructor: (@sel, @el, @cb) ->
    @

  showAt: (x, y) ->
    $menu = $(@sel).show().css
      position: 'absolute'
      left: @menuPosition(x, 'width', 'scrollLeft')
      top: @menuPosition(y, 'height', 'scrollTop')
    $menu.off 'click'
    $menu.on 'click', 'a', (e) =>
      $menu.hide()
      $invokedOn = @el
      $selectedMenu = $(e.target)
      @cb($invokedOn, $selectedMenu)

    $(document).on 'click', ->
      $menu.hide()

  menuPosition: (mouse, direction, scrollDirection) ->
    win = $(window)[direction]()
    scroll = $(window)[scrollDirection]()
    menu = $(@sel)[direction]()
    position = mouse + scroll
    if mouse + menu > win and menu < mouse
      position -= menu
    position

module.exports = ContextMenu
