Model = require 'activer'
Editor = require '../editor.coffee'
Modal = require '../modal.coffee'

exportMenuTmpl = require('../../templates/toolbar_menus/export_menu.hbs')
exportJSONTmpl = require('../../templates/export_json.hbs')

class EditorExporter extends Model
  @belongsTo('Editor')

  afterCreate: ->
    @appendMenu()
    @bindings()

  appendMenu: ->
    @editor().toolbar().append(exportMenuTmpl())

  bindings: ->
    $(document).on 'click', '#export-as-json', (e) =>
      e.stopPropagation()
      content = exportJSONTmpl(val: JSON.stringify(@editor().toJSON()))
      new Modal(content: content).show()

module.exports = EditorExporter
