utils = {}

utils.swap = (a, b) ->
  a = $(a)
  b = $(b)
  tmp = $('<span>').hide()
  a.before(tmp)
  b.before(a)
  tmp.replaceWith(b)

module.exports = utils
