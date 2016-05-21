Model = require 'activer'
Editor = require '../editor.coffee'
Modal = require '../modal.coffee'
addMenuTmpl = require('../../templates/toolbar_menus/add_menu.hbs')

class EditorAdder extends Model
  @belongsTo('Editor')
  @delegate('scenes', 'Editor')
  @delegate('activeScene', 'Editor')
  @delegate('tileSets', 'Editor')

  afterCreate: ->
    @appendMenu()
    @bindings()

  appendMenu: ->
    @editor().toolbar().append(addMenuTmpl())

  bindings: ->
    $(document).on 'click', '#add-scene', (e) =>
      new Modal(
        fields:
          name: ''
          width: ''
          height: ''
        actions:
          Create: (data) =>
            scene = @scenes().create(data)
            scene.renderToEditor()
      ).show()

    $(document).on 'click', '#add-layer', (e) =>
      new Modal(
        fields:
          name: ''
        actions:
          Create: (data) =>
            layer = @activeScene().layers().create(data)
            layer.renderToEditor()
      ).show()

    $(document).on 'click', '#add-tileset', (e) =>
      new Modal(
        fields:
          name: ''
          imagePath: ''
          cols: ''
          rows: ''
          tileOffset: ''
        actions:
          Create: (data) =>
            tileSet = @tileSets().create(data)
            tileSet.renderToEditor()
      ).show()

module.exports = EditorAdder
