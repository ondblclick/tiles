Model = require 'activer'
Editor = require '../editor.coffee'
Tile = require '../tile.coffee'
Layer = require '../layer.coffee'
Scene = require '../scene.coffee'
TileSet = require '../tileset.coffee'
ContextMenu = require '../context_menu.coffee'
# $ = require 'jquery'

class EditorContexter extends Model
  @belongsTo('Editor')

  afterCreate: ->
    @bindings()

  handleContextMenuFor: (e) ->
    res = { using: -> }
    unless e.ctrlKey
      e.preventDefault()
      res.using = (selector, callback) ->
        new ContextMenu(selector, $(e.currentTarget), callback).showAt(e.clientX, e.clientY)
    res

  bindings: ->
    $(document).on 'contextmenu', '.tile', (e) =>
      @handleContextMenuFor(e).using '#tile-context', (invoked, selected) ->
        Tile.find(invoked.data('model-id')).toggleVisibility()

    $(document).on 'contextmenu', '#tileset-tabs li', (e) =>
      @handleContextMenuFor(e).using "#tileset-tab-context", (invoked, selected) ->
        if selected.data('action') is 'remove'
          TileSet.find(invoked.data('model-id')).remove()

    $(document).on 'contextmenu', '.layers-list > li', (e) =>
      @handleContextMenuFor(e).using "#layer-tab-context", (invoked, selected) ->
        if selected.data('action') is 'remove'
          Layer.find(invoked.data('model-id')).remove()

    $(document).on 'contextmenu', '#scene-tabs li', (e) =>
      @handleContextMenuFor(e).using "#scene-pill-context", (invoked, selected) =>
        if selected.data('action') is 'remove'
          Scene.find(invoked.data('model-id')).remove()
        if selected.data('action') is 'edit'
          instance = Scene.find(invoked.data('model-id'))
          @editor().editModalFor(instance, instance.updateAttributes)

module.exports = EditorContexter
