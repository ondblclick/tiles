$ = require 'jquery'

getSelector = (element) ->
  pieces = []
  while element and element.tagName != undefined
    if element.className
      classes = element.className.split(' ')
      for i of classes
        if classes.hasOwnProperty(i) and classes[i]
          pieces.unshift classes[i]
          pieces.unshift '.'
    if element.id and !/\s/.test(element.id)
      pieces.unshift element.id
      pieces.unshift '#'
    pieces.unshift element.tagName
    pieces.unshift ' > '
    element = element.parentNode
  pieces.slice(1).join ''

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
    $(document).on 'contextmenu', getSelector(this), (e) ->
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
