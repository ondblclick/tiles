Editor = require './editor.coffee'

# TODO: update attributes callback to do a rendering to editor stuff?

$(document).ready ->
  editor = Editor.create()
  game = editor.createGame({ tileSize: 48 })

  # tileSet0 = game.tileSets().create
  #   name: 'tielset 0'
  #   imagePath: '../../images/tiles_0.png'
  #   cols: 0
  #   rows: 0
  #   tileOffset: 0

  tileSet1 = game.tileSets().create
    name: 'tileset 1'
    imagePath: '../../images/tiles_1.png'
    cols: 12
    rows: 12
    tileOffset: 2,
    tileOpacityColor: '186,186,186'

  tileSet2 = game.tileSets().create
    name: 'tileset 2'
    imagePath: '../../images/tiles_2.png'
    cols: 6
    rows: 5
    tileOffset: 0,
    tileOpacityColor: '255,255,255'

  scene1 = game.scenes().create({ name: 'very first scene', width: 45, height: 45 })
  scene2 = game.scenes().create({ name: 'second scene', width: 25, height: 25 })
  scene3 = game.scenes().create({ name: 'last scene', width: 10, height: 10 })

  layer1 = scene1.layers().create({ name: 'layer 1', order: 1 })
  layer2 = scene1.layers().create({ name: 'layer 2', order: 3 })
  layer3 = scene1.layers().create({ name: 'layer 3', order: 2 })

  layer4 = scene2.layers().create({ name: 'layer 4', order: 1 })
  layer5 = scene2.layers().create({ name: 'layer 5', order: 2 })
  layer6 = scene2.layers().create({ name: 'layer 6', order: 3 })

  layer7 = scene3.layers().create({ name: 'layer 7', order: 1 })
  layer8 = scene3.layers().create({ name: 'layer 8', order: 3 })
  layer9 = scene3.layers().create({ name: 'layer 9', order: 2 })

  editor.render()
