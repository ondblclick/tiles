Editor = require './editor.coffee'
$ = jQuery = require 'jquery'
require 'bootstrap'

$(document).ready ->
  editor = Editor.create()
  game = editor.createGame({ tileSize: 48 })

  tileSet0 = game.tileSets().create
    name: 'tielset 0'
    imagePath: '../../images/tiles_0.png'
    cols: 0
    rows: 0
    tileOffset: 0

  tileSet1 = game.tileSets().create
    name: 'tileset 1'
    imagePath: '../../images/tiles_1.png'
    cols: 12
    rows: 12
    tileOffset: 2

  tileSet2 = game.tileSets().create
    name: 'tileset 2'
    imagePath: '../../images/tiles_2.png'
    cols: 6
    rows: 5
    tileOffset: 0

  scene1 = game.scenes().create({ name: 'very first scene', width: 10, height: 10 })
  scene2 = game.scenes().create({ name: 'second scene', width: 20, height: 20 })
  scene3 = game.scenes().create({ name: 'last scene', width: 15, height: 15 })

  floor1 = scene1.floors().create({ name: 'floor 1', order: 1 })
  floor2 = scene1.floors().create({ name: 'floor 2', order: 3 })
  floor3 = scene1.floors().create({ name: 'floor 3', order: 2 })

  floor4 = scene2.floors().create({ name: 'floor 4', order: 1 })
  floor5 = scene2.floors().create({ name: 'floor 5', order: 2 })
  floor6 = scene2.floors().create({ name: 'floor 6', order: 3 })

  floor7 = scene3.floors().create({ name: 'floor 7', order: 1 })
  floor8 = scene3.floors().create({ name: 'floor 8', order: 3 })
  floor9 = scene3.floors().create({ name: 'floor 9', order: 2 })

  editor.render()
