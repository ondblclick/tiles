Model = require 'activer'
Editor = require '../editor.coffee'
exportMenuTemplate = require('../../templates/export_menu.hbs')

class EditorExporter extends Model
  @belongsTo('Editor')

  afterCreate: ->
    @appendMenu()
    @bindings()

  appendMenu: ->
    @editor().toolbar().append(exportMenuTemplate())

  bindings: ->
    $(document).on 'click', '#export-as-json', (e) =>
      e.stopPropagation()
      $('#export-as-json-modal').find('textarea').val(JSON.stringify(@editor().toJSON()))
      $('#export-as-json-modal').modal('show')

module.exports = EditorExporter