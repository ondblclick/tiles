Model = require 'activer'
Editor = require '../editor.coffee'
emportMenuTemplate = require('../../templates/import_menu.hbs')

class EditorImporter extends Model
  @belongsTo('Editor')

  afterCreate: ->
    @appendMenu()

  appendMenu: ->
    @editor().toolbar().append(emportMenuTemplate())

module.exports = EditorImporter
