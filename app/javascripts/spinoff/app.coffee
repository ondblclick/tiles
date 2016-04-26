Editor = require './editor.coffee'
$ = require 'jquery'

$(document).on 'click', '[data-tabs-for] > li', (e) ->
  tab = $(e.target)
  tabList = tab.parents('[data-tabs-for]')
  selector = tabList.data('tabs-for')
  attr = tabList.data('tabs-attr')
  val = tab.attr(attr)
  container = $("#{selector} > li[#{attr}='#{val}']")
  [tab, container].forEach (el) -> el.addClass('is-active').siblings().removeClass('is-active')

$(document).ready ->
  editor = Editor.create()
  game = editor.createGame({ tileSize: 32 })
  tileSet1 = game.tileSets().create()
  tileSet2 = game.tileSets().create()
  tileSet3 = game.tileSets().create()
  scene1 = game.scenes().create({ name: 'very first scene', width: 10, height: 10 })
  scene2 = game.scenes().create({ name: 'second scene', width: 20, height: 20 })
  scene3 = game.scenes().create({ name: 'last scene', width: 15, height: 15 })
  floor1 = scene1.floors().create({ name: 'floor 1' })
  floor2 = scene1.floors().create({ name: 'floor 2' })
  floor3 = scene1.floors().create({ name: 'floor 3' })

  floor4 = scene2.floors().create({ name: 'floor 4' })
  floor5 = scene2.floors().create({ name: 'floor 5' })
  floor6 = scene2.floors().create({ name: 'floor 6' })

  floor7 = scene3.floors().create({ name: 'floor 7' })
  floor8 = scene3.floors().create({ name: 'floor 8' })
  floor9 = scene3.floors().create({ name: 'floor 9' })


  editor.render()

# class Editor
#   @hasOne('Game')
#
# class GameRunner
#   @hasOne('Game')
#
# class Game
#   @hasMany('TileSet', 'Scene')
#   @belongsTo('Editor', 'GameRunner')
#
# class TileSet
#   @belongsTo('Game')
#
# class Scene
#   @hasMany('Floor')
#   @belongsTo('Game')
#
# class Floor
#   @belongsTo('Scene')
#   @hasMany('Cell')
#
# class Cell
#   @hasOne('Terrain', 'Unit')
#   @hasMany('Item')
#   @belongsTo('Floor')
#
# class Terrain
#   @belongsTo('Cell')
#
# class Unit
#   @belongsTo('Cell')
