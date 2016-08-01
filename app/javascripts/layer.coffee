Model = require 'activer'
Scene = require './scene.coffee'
Chunk = require './chunk.coffee'
utils = require './utils.coffee'

tabTmpl = require '../templates/layer_tab.hbs'

class Layer extends Model
  @attributes('name', 'order')
  @belongsTo('Scene')
  @hasMany('Chunk', { dependent: 'destroy' })
  @hasMany('Cell', { dependent: 'destroy' })
  @delegate('game', 'Scene')

  toJSON: ->
    res = super()
    res.chunks = @chunks().map((chunk) -> chunk.toJSON())
    res

  createChunks: ->
    Chunk.createChunksFor(@, @scene())

  afterCreate: ->
    @createChunks()

  renderToEditor: ->
    $("#scene-containers > li[data-model-id='#{@scene().id}'] .layers-list").append(tabTmpl(@toJSON()))

  removeFromEditor: ->
    $(".layers-list .nav-item[data-model-id='#{@id}']").remove()

  remove: ->
    @removeFromEditor()
    @destroy()

module.exports = Layer
