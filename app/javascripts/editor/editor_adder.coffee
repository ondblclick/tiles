Model = require 'activer'
Editor = require '../editor.coffee'

class EditorAdder extends Model
  @belongsTo('Editor')
  @delegate('scenes', 'Editor')
  @delegate('activeScene', 'Editor')

  afterCreate: ->
    @appendMenu()
    @bindings()

  appendMenu: ->
    tmpl = $.templates('#add-menu')
    @editor().toolbar().append(tmpl)

  newModalFor: (attributes, onSubmit) ->
    $form = $('#new-modal form')
    $form.empty()
    textFieldTmpl = $.templates('#text-field')
    attributes.forEach (field) ->
      $form.append(textFieldTmpl.render({ name: field, value: '' }))
    $('#new-modal button').off 'click'
    $('#new-modal button').on 'click', ->
      data = {}
      $form.serializeArray().map (x) -> data[x.name] = x.value
      onSubmit(data)
      $('#new-modal').modal('hide')
    $('#new-modal').modal('show')

  bindings: ->
    $(document).on 'click', '#add-scene', (e) =>
      @newModalFor ['name', 'width', 'height'], (data) =>
        scene = @scenes().create(data)
        scene.renderToEditor()

    $(document).on 'click', '#add-layer', (e) =>
      @newModalFor ['name'], (data) =>
        layer = @activeScene().layers().create(data)
        layer.renderToEditor()

    $(document).on 'click', '#add-tileset', (e) =>
      @newModalFor ['name', 'imagePath', 'cols', 'rows', 'tileOffset'], (data) =>
        tileSet = @tileSets().create(data)
        tileSet.renderToEditor()

module.exports = EditorAdder
