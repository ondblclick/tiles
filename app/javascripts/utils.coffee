utils = {}

utils.swap = (a, b) ->
  a = $(a)
  b = $(b)
  tmp = $('<span>').hide()
  a.before(tmp)
  b.before(a)
  tmp.replaceWith(b)

utils.canvas =
  fill: (context, image, width, height) ->
    pattern = context.createPattern(image, 'repeat')
    context.rect(0, 0, context.canvas.width, context.canvas.height)
    context.fillStyle = pattern
    context.fill()

  create: (width, height) ->
    canvas = document.createElement('canvas')
    canvas.width = width
    canvas.height = height
    canvas

module.exports = utils
