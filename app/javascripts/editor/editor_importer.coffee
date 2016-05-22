Model = require 'activer'
Editor = require '../editor.coffee'

emportMenuTmpl = require '../../templates/toolbar_menus/import_menu.hbs'

class EditorImporter extends Model
  @belongsTo('Editor')

  afterCreate: ->
    @appendMenu()

  appendMenu: ->
    @editor().menubar().append(emportMenuTmpl())

module.exports = EditorImporter
