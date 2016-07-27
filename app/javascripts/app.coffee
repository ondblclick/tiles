Editor = require './editor.coffee'
Tile = require './tile.coffee'
Layer = require './layer.coffee'
Scene = require './scene.coffee'
TileSet = require './tileset.coffee'
Cell = require './cell.coffee'
Game = require './game.coffee'

$(document).ready ->
  # game = Game.create({ tileSize: 48 })
  # #
  # # tileSet0 = game.tileSets().create
  # #   name: 'tielset 0'
  # #   imagePath: '../../images/tiles_0.png'
  # #   cols: 0
  # #   rows: 0
  # #   tileOffset: 0
  # #
  # # tileSet1 = game.tileSets().create
  # #   name: 'tileset 1'
  # #   imagePath: '../../images/tiles_1.png'
  # #   cols: 12
  # #   rows: 12
  # #   tileOffset: 2,
  # #   tileOpacityColor: '186,186,186'
  # #
  # tileSet2 = game.tileSets().create
  #   name: 'tileset 2'
  #   imagePath: '../../images/tiles_2.png'
  #   cols: 6
  #   rows: 5
  #   tileOffset: 0,
  #   tileOpacityColor: '255,255,255'
  #
  # scene3 = game.scenes().create({ name: 'last scene', width: 5, height: 5 })
  # # scene1 = game.scenes().create({ name: 'very first scene', width: 115, height: 115 })
  # # scene2 = game.scenes().create({ name: 'second scene', width: 25, height: 25 })
  #
  # # layer1 = scene1.layers().create({ name: 'layer 1', order: 1 })
  # # layer2 = scene1.layers().create({ name: 'layer 2', order: 3 })
  # # layer3 = scene1.layers().create({ name: 'layer 3', order: 2 })
  #
  # # layer4 = scene2.layers().create({ name: 'layer 4', order: 1 })
  # # layer5 = scene2.layers().create({ name: 'layer 5', order: 2 })
  # # layer6 = scene2.layers().create({ name: 'layer 6', order: 3 })
  #
  # layer7 = scene3.layers().create({ name: 'layer 7', order: 1 })
  # # layer8 = scene3.layers().create({ name: 'layer 8', order: 3 })
  # # layer9 = scene3.layers().create({ name: 'layer 9', order: 2 })
  #
  # window.editor = new Editor(game)
  # editor.render()

  resp = {
    "TileSet": [
      {
        "name": "tileset 2",
        "imagePath": "../../images/tiles_2.png",
        "cols": 6,
        "rows": 5,
        "tileOffset": 0,
        "tileOpacityColor": "255,255,255",
        "gameId": "game1",
        "id": "tileSet2",
        "img": {},
        "style": {},
        "tiles": [
          {
            "id": "tile3",
            "x": 0,
            "y": 0,
            "display": "is-visible",
            "tileSetId": "tileSet2"
          },
          {
            "id": "tile4",
            "x": 0,
            "y": 48,
            "display": "is-visible",
            "tileSetId": "tileSet2"
          },
          {
            "id": "tile5",
            "x": 0,
            "y": 96,
            "display": "is-visible",
            "tileSetId": "tileSet2"
          },
          {
            "id": "tile6",
            "x": 0,
            "y": 144,
            "display": "is-visible",
            "tileSetId": "tileSet2"
          },
          {
            "id": "tile7",
            "x": 0,
            "y": 192,
            "display": "is-visible",
            "tileSetId": "tileSet2"
          },
          {
            "id": "tile8",
            "x": 48,
            "y": 0,
            "display": "is-visible",
            "tileSetId": "tileSet2"
          },
          {
            "id": "tile9",
            "x": 48,
            "y": 48,
            "display": "is-visible",
            "tileSetId": "tileSet2"
          },
          {
            "id": "tile10",
            "x": 48,
            "y": 96,
            "display": "is-visible",
            "tileSetId": "tileSet2"
          },
          {
            "id": "tile11",
            "x": 48,
            "y": 144,
            "display": "is-visible",
            "tileSetId": "tileSet2"
          },
          {
            "id": "tile12",
            "x": 48,
            "y": 192,
            "display": "is-visible",
            "tileSetId": "tileSet2"
          },
          {
            "id": "tile13",
            "x": 96,
            "y": 0,
            "display": "is-visible",
            "tileSetId": "tileSet2"
          },
          {
            "id": "tile14",
            "x": 96,
            "y": 48,
            "display": "is-visible",
            "tileSetId": "tileSet2"
          },
          {
            "id": "tile15",
            "x": 96,
            "y": 96,
            "display": "is-visible",
            "tileSetId": "tileSet2"
          },
          {
            "id": "tile16",
            "x": 96,
            "y": 144,
            "display": "is-visible",
            "tileSetId": "tileSet2"
          },
          {
            "id": "tile17",
            "x": 96,
            "y": 192,
            "display": "is-visible",
            "tileSetId": "tileSet2"
          },
          {
            "id": "tile18",
            "x": 144,
            "y": 0,
            "display": "is-visible",
            "tileSetId": "tileSet2"
          },
          {
            "id": "tile19",
            "x": 144,
            "y": 48,
            "display": "is-visible",
            "tileSetId": "tileSet2"
          },
          {
            "id": "tile20",
            "x": 144,
            "y": 96,
            "display": "is-visible",
            "tileSetId": "tileSet2"
          },
          {
            "id": "tile21",
            "x": 144,
            "y": 144,
            "display": "is-visible",
            "tileSetId": "tileSet2"
          },
          {
            "id": "tile22",
            "x": 144,
            "y": 192,
            "display": "is-visible",
            "tileSetId": "tileSet2"
          },
          {
            "id": "tile23",
            "x": 192,
            "y": 0,
            "display": "is-visible",
            "tileSetId": "tileSet2"
          },
          {
            "id": "tile24",
            "x": 192,
            "y": 48,
            "display": "is-visible",
            "tileSetId": "tileSet2"
          },
          {
            "id": "tile25",
            "x": 192,
            "y": 96,
            "display": "is-visible",
            "tileSetId": "tileSet2"
          },
          {
            "id": "tile26",
            "x": 192,
            "y": 144,
            "display": "is-visible",
            "tileSetId": "tileSet2"
          },
          {
            "id": "tile27",
            "x": 192,
            "y": 192,
            "display": "is-visible",
            "tileSetId": "tileSet2"
          },
          {
            "id": "tile28",
            "x": 240,
            "y": 0,
            "display": "is-visible",
            "tileSetId": "tileSet2"
          },
          {
            "id": "tile29",
            "x": 240,
            "y": 48,
            "display": "is-visible",
            "tileSetId": "tileSet2"
          },
          {
            "id": "tile30",
            "x": 240,
            "y": 96,
            "display": "is-visible",
            "tileSetId": "tileSet2"
          },
          {
            "id": "tile31",
            "x": 240,
            "y": 144,
            "display": "is-visible",
            "tileSetId": "tileSet2"
          },
          {
            "id": "tile32",
            "x": 240,
            "y": 192,
            "display": "is-visible",
            "tileSetId": "tileSet2"
          }
        ]
      }
    ],
    "Tile": [
      {
        "x": 0,
        "y": 0,
        "display": "is-visible",
        "tileSetId": "tileSet2",
        "id": "tile3"
      },
      {
        "x": 0,
        "y": 48,
        "display": "is-visible",
        "tileSetId": "tileSet2",
        "id": "tile4"
      },
      {
        "x": 0,
        "y": 96,
        "display": "is-visible",
        "tileSetId": "tileSet2",
        "id": "tile5"
      },
      {
        "x": 0,
        "y": 144,
        "display": "is-visible",
        "tileSetId": "tileSet2",
        "id": "tile6"
      },
      {
        "x": 0,
        "y": 192,
        "display": "is-visible",
        "tileSetId": "tileSet2",
        "id": "tile7"
      },
      {
        "x": 48,
        "y": 0,
        "display": "is-visible",
        "tileSetId": "tileSet2",
        "id": "tile8"
      },
      {
        "x": 48,
        "y": 48,
        "display": "is-visible",
        "tileSetId": "tileSet2",
        "id": "tile9"
      },
      {
        "x": 48,
        "y": 96,
        "display": "is-visible",
        "tileSetId": "tileSet2",
        "id": "tile10"
      },
      {
        "x": 48,
        "y": 144,
        "display": "is-visible",
        "tileSetId": "tileSet2",
        "id": "tile11"
      },
      {
        "x": 48,
        "y": 192,
        "display": "is-visible",
        "tileSetId": "tileSet2",
        "id": "tile12"
      },
      {
        "x": 96,
        "y": 0,
        "display": "is-visible",
        "tileSetId": "tileSet2",
        "id": "tile13"
      },
      {
        "x": 96,
        "y": 48,
        "display": "is-visible",
        "tileSetId": "tileSet2",
        "id": "tile14"
      },
      {
        "x": 96,
        "y": 96,
        "display": "is-visible",
        "tileSetId": "tileSet2",
        "id": "tile15"
      },
      {
        "x": 96,
        "y": 144,
        "display": "is-visible",
        "tileSetId": "tileSet2",
        "id": "tile16"
      },
      {
        "x": 96,
        "y": 192,
        "display": "is-visible",
        "tileSetId": "tileSet2",
        "id": "tile17"
      },
      {
        "x": 144,
        "y": 0,
        "display": "is-visible",
        "tileSetId": "tileSet2",
        "id": "tile18"
      },
      {
        "x": 144,
        "y": 48,
        "display": "is-visible",
        "tileSetId": "tileSet2",
        "id": "tile19"
      },
      {
        "x": 144,
        "y": 96,
        "display": "is-visible",
        "tileSetId": "tileSet2",
        "id": "tile20"
      },
      {
        "x": 144,
        "y": 144,
        "display": "is-visible",
        "tileSetId": "tileSet2",
        "id": "tile21"
      },
      {
        "x": 144,
        "y": 192,
        "display": "is-visible",
        "tileSetId": "tileSet2",
        "id": "tile22"
      },
      {
        "x": 192,
        "y": 0,
        "display": "is-visible",
        "tileSetId": "tileSet2",
        "id": "tile23"
      },
      {
        "x": 192,
        "y": 48,
        "display": "is-visible",
        "tileSetId": "tileSet2",
        "id": "tile24"
      },
      {
        "x": 192,
        "y": 96,
        "display": "is-visible",
        "tileSetId": "tileSet2",
        "id": "tile25"
      },
      {
        "x": 192,
        "y": 144,
        "display": "is-visible",
        "tileSetId": "tileSet2",
        "id": "tile26"
      },
      {
        "x": 192,
        "y": 192,
        "display": "is-visible",
        "tileSetId": "tileSet2",
        "id": "tile27"
      },
      {
        "x": 240,
        "y": 0,
        "display": "is-visible",
        "tileSetId": "tileSet2",
        "id": "tile28"
      },
      {
        "x": 240,
        "y": 48,
        "display": "is-visible",
        "tileSetId": "tileSet2",
        "id": "tile29"
      },
      {
        "x": 240,
        "y": 96,
        "display": "is-visible",
        "tileSetId": "tileSet2",
        "id": "tile30"
      },
      {
        "x": 240,
        "y": 144,
        "display": "is-visible",
        "tileSetId": "tileSet2",
        "id": "tile31"
      },
      {
        "x": 240,
        "y": 192,
        "display": "is-visible",
        "tileSetId": "tileSet2",
        "id": "tile32"
      }
    ],
    "Scene": [
      {
        "name": "last scene",
        "width": 5,
        "height": 5,
        "gameId": "game1",
        "id": "scene33"
      }
    ],
    "Layer": [
      {
        "name": "layer 7",
        "order": 1,
        "sceneId": "scene33",
        "id": "layer35"
      }
    ],
    "Cell": [
      {
        "col": 4,
        "row": 0,
        "tileId": "tile3",
        "layerId": "layer35",
        "id": "cell37"
      },
      {
        "col": 3,
        "row": 1,
        "tileId": "tile3",
        "layerId": "layer35",
        "id": "cell38"
      },
      {
        "col": 1,
        "row": 3,
        "tileId": "tile28",
        "layerId": "layer35",
        "id": "cell39"
      },
      {
        "col": 0,
        "row": 4,
        "tileId": "tile28",
        "layerId": "layer35",
        "id": "cell40"
      }
    ],
    "Game": [
      {
        "tileSize": 48,
        "id": "game1"
      }
    ]
  }

  Game.dao()._collection = resp.Game.slice(0)
  Tile.dao()._collection = resp.Tile.slice(0)
  TileSet.dao()._collection = resp.TileSet.slice(0)
  Layer.dao()._collection = resp.Layer.slice(0)
  Scene.dao()._collection = resp.Scene.slice(0)
  Cell.dao()._collection = resp.Cell.slice(0)

  window.editor = new Editor(Game.all()[0])
  editor.render()
