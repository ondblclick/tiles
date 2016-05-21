class ContextMenu
  constructor: (@tmpl, @el, @cb) ->
    @

  showAt: (x, y) ->
    $(document).click()
    $menu = $($.parseHTML(@tmpl))
    $('body').append($menu)
    $menu.show().css
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
      $menu.remove()

  menuPosition: (mouse, direction, scrollDirection) ->
    win = $(window)[direction]()
    scroll = $(window)[scrollDirection]()
    menu = $(@sel)[direction]()
    position = mouse + scroll
    if mouse + menu > win and menu < mouse
      position -= menu
    position

module.exports = ContextMenu
