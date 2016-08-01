Layer = require '../layer.coffee'
Scene = require '../scene.coffee'
Cell = require '../cell.coffee'
Chunk = require '../chunk.coffee'

class EditorHistorian
  constructor: (@editor) ->
    @bindings()
    @undoList = []
    @redoList = []

  changeStateTo: ({ Layer, Scene, Cell }) ->
    Chunk.dao()._collection = []
    Layer.dao()._collection = Layer.slice(0)
    Scene.dao()._collection = Scene.slice(0)
    Cell.dao()._collection = Cell.slice(0)
    @editor.scenes().forEach (scene) -> scene.render()

  undo: ->
    item = @undoList.pop()
    return unless item
    @saveState('undo', 'redo')
    @changeStateTo(item.state)

  redo: ->
    item = @redoList.pop()
    return unless item
    @saveState('redo', 'undo')
    @changeStateTo(item.state)

  saveState: (action, type = 'undo') ->
    @["#{type}List"].push
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
