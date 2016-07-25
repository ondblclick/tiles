importMenuTmpl = require '../../templates/toolbar_menus/import_menu.hbs'

class EditorImporter
  constructor: (@editor) ->
    @appendMenu()

  appendMenu: ->
    @editor.menubar().append(importMenuTmpl())

module.exports = EditorImporter
