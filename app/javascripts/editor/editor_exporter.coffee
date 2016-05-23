Model = require 'activer'
Editor = require '../editor.coffee'
Modal = require '../modal.coffee'

exportMenuTmpl = require '../../templates/toolbar_menus/export_menu.hbs'
exportJSONTmpl = require '../../templates/export_json.hbs'

class EditorExporter extends Model
  @belongsTo('Editor')

  afterCreate: ->
    @appendMenu()
    @bindings()

  appendMenu: ->
    @editor().menubar().append(exportMenuTmpl())

  bindings: ->
    $(document).on 'click', '#export-as-json', (e) =>
      e.stopPropagation()
      content = exportJSONTmpl(val: JSON.stringify(@editor().toJSON()))
      new Modal(content: content).show()

    $(document).on 'click', '#export-as-image', (e) =>
      e.stopPropagation()
      height = 0
      width = 0
      heightOffset = 0

      @editor().game().scenes().forEach (scene) =>
        width = Math.max(width, scene.width * @editor().game().tileSize)
        height += scene.height * @editor().game().tileSize + @editor().game().tileSize

      canvas = document.createElement('canvas')
      canvas.height = height
      canvas.width = width
      canvas.style.maxWidth = '100%'
      ctx = canvas.getContext('2d')

      @editor().game().scenes().forEach (scene) =>
        ctx.drawImage(scene.canvas()[0], 0, heightOffset)
        heightOffset += scene.canvas()[0].height + @editor().game().tileSize

      new Modal(
        content: canvas
        actions:
          Download: canvas.toDataURL('image/png')
      ).show()

module.exports = EditorExporter
