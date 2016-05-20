Model = require 'activer'
Editor = require '../editor.coffee'
# $ = require 'jquery'

class EditorImporter extends Model
  @belongsTo('Editor')

  afterCreate: ->
    @appendMenu()

  appendMenu: ->
    tmpl = $.templates('#import-menu')
    @editor().toolbar().append(tmpl)

module.exports = EditorImporter
