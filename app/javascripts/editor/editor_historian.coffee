Layer = require '../layer.coffee'
Scene = require '../scene.coffee'
Cell = require '../cell.coffee'
Chunk = require '../chunk.coffee'

class EditorHistorian
  constructor: (@editor) ->
    @bindings()
    @history = []

  undo: ->
    item = @history.pop()
    return unless item
    Chunk.dao()._collection = []
    Layer.dao()._collection = item.state.Layer.slice(0)
    Scene.dao()._collection = item.state.Scene.slice(0)
    Cell.dao()._collection = item.state.Cell.slice(0)
    @editor.scenes().forEach (scene) -> scene.render()

  redo: ->
    console.log 'redo'

  saveState: (action) ->
    @history.push
      action: action
      state: @getState()

  getState: ->
    Layer: Layer.dao()._collection.slice(0)
    Scene: Scene.dao()._collection.slice(0)
    Cell: Cell.dao()._collection.slice(0)

  bindings: ->
    $(document).on 'click', '#undo', (e) =>
      e.preventDefault()
      @undo()

    $(document).on 'click', '#redo', (e) =>
      e.preventDefault()
      @redo()

module.exports = EditorHistorian
