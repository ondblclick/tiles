formTmpl = require '../templates/form.hbs'

class Modal
  constructor: ({ @fields, @actions, @content }) ->
    content = if @content
      @content
    else
      res = []
      for k, v of @fields
        res.push { name: k, value: v }
      formTmpl({ fields: res })
    $('#modal .modal-body').html(content)
    $('#modal .modal-footer').empty()
    for k, v of @actions
      button = $("<button class='btn btn-secondary'>#{k}</button>")
      button.on 'click', ->
        data = {}
        $('#modal .modal-body form').serializeArray().map (x) -> data[x.name] = x.value
        v(data)
        $('#modal').modal('hide')

      $('#modal .modal-footer').append(button)

    cancel = "<button type='button' class='btn btn-secondary' data-dismiss='modal'>Close</button>"
    $('#modal .modal-footer').append(cancel)
    @

  show: ->
    $('#modal').modal('show')

module.exports = Modal
