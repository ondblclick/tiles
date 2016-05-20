Model = require 'activer'
Editor = require '../editor.coffee'
# $ = require 'jquery'

class EditorExporter extends Model
  @belongsTo('Editor')

  afterCreate: ->
    @appendMenu()
    @bindings()

  appendMenu: ->
    tmpl = $.templates('#export-menu')
    @editor().toolbar().append(tmpl)

  bindings: ->
    $(document).on 'click', '#export-as-json', (e) =>
      e.stopPropagation()
      $('#export-as-json-modal').find('textarea').val(JSON.stringify(@editor().toJSON()))
      $('#export-as-json-modal').modal('show')

module.exports = EditorExporter
