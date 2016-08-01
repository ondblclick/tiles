Modal = require '../modal.coffee'

addMenuTmpl = require '../../templates/toolbar_menus/add_menu.hbs'

class EditorAdder
  constructor: (@editor) ->
    @bindings()

  appendMenu: ->
    @editor.menubar().append(addMenuTmpl())

  bindings: ->
    $(document).on 'click', '#add-scene', (e) =>
      new Modal(
        fields:
          name: ''
          width: ''
          height: ''
        actions:
          Create: (data) =>
            scene = @editor.scenes().create(data)
            scene.renderToEditor()
      ).show()

    $(document).on 'click', '#add-layer', (e) =>
      new Modal(
        fields:
          name: ''
        actions:
          Create: (data) =>
            layer = @editor.activeScene().layers().create(data)
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
            tileSet = @editor.tileSets().create(data)
            tileSet.renderToEditor()
      ).show()

module.exports = EditorAdder
