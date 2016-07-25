class EditorScroller
  constructor: (@editor) ->
    @bindings()
    @dragScroll = false
    @dragScrollStartX = 0
    @dragScrollStartY = 0

  bindings: ->
    $(document).on 'mousedown', 'canvas', (e) =>
      return unless @editor.keyPressed(32)
      @dragScroll = true
      @dragScrollStartX = e.pageX
      @dragScrollStartY = e.pageY

    $(document).on 'mouseup', (e) =>
      return unless @dragScroll
      @dragScroll = false

    $(document).on 'mousemove', (e) =>
      return unless @dragScroll
      deltaX = e.pageX - @dragScrollStartX
      deltaY = e.pageY - @dragScrollStartY
      el = $('.tab-pane.active .canvas-container')
      el.scrollLeft(el.scrollLeft() - deltaX)
      el.scrollTop(el.scrollTop() - deltaY)
      @dragScrollStartX = e.pageX
      @dragScrollStartY = e.pageY

module.exports = EditorScroller
