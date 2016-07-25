Editor = require './editor.coffee'
Tile = require './tile.coffee'
Layer = require './layer.coffee'
Scene = require './scene.coffee'
TileSet = require './tileset.coffee'
Cell = require './cell.coffee'
Game = require './game.coffee'

$(document).ready ->
  # game = Game.create({ tileSize: 48 })
  #
  # tileSet0 = game.tileSets().create
  #   name: 'tielset 0'
  #   imagePath: '../../images/tiles_0.png'
  #   cols: 0
  #   rows: 0
  #   tileOffset: 0
  #
  # tileSet1 = game.tileSets().create
  #   name: 'tileset 1'
  #   imagePath: '../../images/tiles_1.png'
  #   cols: 12
  #   rows: 12
  #   tileOffset: 2,
  #   tileOpacityColor: '186,186,186'
  #
  # tileSet2 = game.tileSets().create
  #   name: 'tileset 2'
  #   imagePath: '../../images/tiles_2.png'
  #   cols: 6
  #   rows: 5
  #   tileOffset: 0,
  #   tileOpacityColor: '255,255,255'

  # scene3 = game.scenes().create({ name: 'last scene', width: 5, height: 5 })
  # scene1 = game.scenes().create({ name: 'very first scene', width: 115, height: 115 })
  # scene2 = game.scenes().create({ name: 'second scene', width: 25, height: 25 })

  # layer1 = scene1.layers().create({ name: 'layer 1', order: 1 })
  # layer2 = scene1.layers().create({ name: 'layer 2', order: 3 })
  # layer3 = scene1.layers().create({ name: 'layer 3', order: 2 })

  # layer4 = scene2.layers().create({ name: 'layer 4', order: 1 })
  # layer5 = scene2.layers().create({ name: 'layer 5', order: 2 })
  # layer6 = scene2.layers().create({ name: 'layer 6', order: 3 })

  # layer7 = scene3.layers().create({ name: 'layer 7', order: 1 })
  # layer8 = scene3.layers().create({ name: 'layer 8', order: 3 })
  # layer9 = scene3.layers().create({ name: 'layer 9', order: 2 })

  resp = {
    "Game": [
      {
        "id": "game1",
        "tileSize": "48"
      }
    ],
    "TileSet": [
      {
        "name": "tielset 0",
        "imagePath": "../../images/tiles_0.png",
        "cols": 0,
        "rows": 0,
        "tileOffset": 0,
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
            "y": -48,
            "display": "is-visible",
            "tileSetId": "tileSet2"
          },
          {
            "id": "tile5",
            "x": -48,
            "y": 0,
            "display": "is-visible",
            "tileSetId": "tileSet2"
          },
          {
            "id": "tile6",
            "x": -48,
            "y": -48,
            "display": "is-visible",
            "tileSetId": "tileSet2"
          }
        ]
      },
      {
        "name": "tileset 1",
        "imagePath": "../../images/tiles_1.png",
        "cols": 12,
        "rows": 12,
        "tileOffset": 2,
        "tileOpacityColor": "186,186,186",
        "gameId": "game1",
        "id": "tileSet7",
        "img": {},
        "style": {},
        "tiles": [
          {
            "id": "tile8",
            "x": 2,
            "y": 2,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile9",
            "x": 2,
            "y": 52,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile10",
            "x": 2,
            "y": 102,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile11",
            "x": 2,
            "y": 152,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile12",
            "x": 2,
            "y": 202,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile13",
            "x": 2,
            "y": 252,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile14",
            "x": 2,
            "y": 302,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile15",
            "x": 2,
            "y": 352,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile16",
            "x": 2,
            "y": 402,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile17",
            "x": 2,
            "y": 452,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile18",
            "x": 2,
            "y": 502,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile19",
            "x": 2,
            "y": 552,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile20",
            "x": 52,
            "y": 2,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile21",
            "x": 52,
            "y": 52,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile22",
            "x": 52,
            "y": 102,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile23",
            "x": 52,
            "y": 152,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile24",
            "x": 52,
            "y": 202,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile25",
            "x": 52,
            "y": 252,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile26",
            "x": 52,
            "y": 302,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile27",
            "x": 52,
            "y": 352,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile28",
            "x": 52,
            "y": 402,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile29",
            "x": 52,
            "y": 452,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile30",
            "x": 52,
            "y": 502,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile31",
            "x": 52,
            "y": 552,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile32",
            "x": 102,
            "y": 2,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile33",
            "x": 102,
            "y": 52,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile34",
            "x": 102,
            "y": 102,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile35",
            "x": 102,
            "y": 152,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile36",
            "x": 102,
            "y": 202,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile37",
            "x": 102,
            "y": 252,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile38",
            "x": 102,
            "y": 302,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile39",
            "x": 102,
            "y": 352,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile40",
            "x": 102,
            "y": 402,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile41",
            "x": 102,
            "y": 452,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile42",
            "x": 102,
            "y": 502,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile43",
            "x": 102,
            "y": 552,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile44",
            "x": 152,
            "y": 2,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile45",
            "x": 152,
            "y": 52,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile46",
            "x": 152,
            "y": 102,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile47",
            "x": 152,
            "y": 152,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile48",
            "x": 152,
            "y": 202,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile49",
            "x": 152,
            "y": 252,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile50",
            "x": 152,
            "y": 302,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile51",
            "x": 152,
            "y": 352,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile52",
            "x": 152,
            "y": 402,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile53",
            "x": 152,
            "y": 452,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile54",
            "x": 152,
            "y": 502,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile55",
            "x": 152,
            "y": 552,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile56",
            "x": 202,
            "y": 2,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile57",
            "x": 202,
            "y": 52,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile58",
            "x": 202,
            "y": 102,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile59",
            "x": 202,
            "y": 152,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile60",
            "x": 202,
            "y": 202,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile61",
            "x": 202,
            "y": 252,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile62",
            "x": 202,
            "y": 302,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile63",
            "x": 202,
            "y": 352,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile64",
            "x": 202,
            "y": 402,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile65",
            "x": 202,
            "y": 452,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile66",
            "x": 202,
            "y": 502,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile67",
            "x": 202,
            "y": 552,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile68",
            "x": 252,
            "y": 2,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile69",
            "x": 252,
            "y": 52,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile70",
            "x": 252,
            "y": 102,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile71",
            "x": 252,
            "y": 152,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile72",
            "x": 252,
            "y": 202,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile73",
            "x": 252,
            "y": 252,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile74",
            "x": 252,
            "y": 302,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile75",
            "x": 252,
            "y": 352,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile76",
            "x": 252,
            "y": 402,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile77",
            "x": 252,
            "y": 452,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile78",
            "x": 252,
            "y": 502,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile79",
            "x": 252,
            "y": 552,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile80",
            "x": 302,
            "y": 2,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile81",
            "x": 302,
            "y": 52,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile82",
            "x": 302,
            "y": 102,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile83",
            "x": 302,
            "y": 152,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile84",
            "x": 302,
            "y": 202,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile85",
            "x": 302,
            "y": 252,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile86",
            "x": 302,
            "y": 302,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile87",
            "x": 302,
            "y": 352,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile88",
            "x": 302,
            "y": 402,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile89",
            "x": 302,
            "y": 452,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile90",
            "x": 302,
            "y": 502,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile91",
            "x": 302,
            "y": 552,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile92",
            "x": 352,
            "y": 2,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile93",
            "x": 352,
            "y": 52,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile94",
            "x": 352,
            "y": 102,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile95",
            "x": 352,
            "y": 152,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile96",
            "x": 352,
            "y": 202,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile97",
            "x": 352,
            "y": 252,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile98",
            "x": 352,
            "y": 302,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile99",
            "x": 352,
            "y": 352,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile100",
            "x": 352,
            "y": 402,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile101",
            "x": 352,
            "y": 452,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile102",
            "x": 352,
            "y": 502,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile103",
            "x": 352,
            "y": 552,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile104",
            "x": 402,
            "y": 2,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile105",
            "x": 402,
            "y": 52,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile106",
            "x": 402,
            "y": 102,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile107",
            "x": 402,
            "y": 152,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile108",
            "x": 402,
            "y": 202,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile109",
            "x": 402,
            "y": 252,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile110",
            "x": 402,
            "y": 302,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile111",
            "x": 402,
            "y": 352,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile112",
            "x": 402,
            "y": 402,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile113",
            "x": 402,
            "y": 452,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile114",
            "x": 402,
            "y": 502,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile115",
            "x": 402,
            "y": 552,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile116",
            "x": 452,
            "y": 2,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile117",
            "x": 452,
            "y": 52,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile118",
            "x": 452,
            "y": 102,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile119",
            "x": 452,
            "y": 152,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile120",
            "x": 452,
            "y": 202,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile121",
            "x": 452,
            "y": 252,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile122",
            "x": 452,
            "y": 302,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile123",
            "x": 452,
            "y": 352,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile124",
            "x": 452,
            "y": 402,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile125",
            "x": 452,
            "y": 452,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile126",
            "x": 452,
            "y": 502,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile127",
            "x": 452,
            "y": 552,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile128",
            "x": 502,
            "y": 2,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile129",
            "x": 502,
            "y": 52,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile130",
            "x": 502,
            "y": 102,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile131",
            "x": 502,
            "y": 152,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile132",
            "x": 502,
            "y": 202,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile133",
            "x": 502,
            "y": 252,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile134",
            "x": 502,
            "y": 302,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile135",
            "x": 502,
            "y": 352,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile136",
            "x": 502,
            "y": 402,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile137",
            "x": 502,
            "y": 452,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile138",
            "x": 502,
            "y": 502,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile139",
            "x": 502,
            "y": 552,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile140",
            "x": 552,
            "y": 2,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile141",
            "x": 552,
            "y": 52,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile142",
            "x": 552,
            "y": 102,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile143",
            "x": 552,
            "y": 152,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile144",
            "x": 552,
            "y": 202,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile145",
            "x": 552,
            "y": 252,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile146",
            "x": 552,
            "y": 302,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile147",
            "x": 552,
            "y": 352,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile148",
            "x": 552,
            "y": 402,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile149",
            "x": 552,
            "y": 452,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile150",
            "x": 552,
            "y": 502,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          },
          {
            "id": "tile151",
            "x": 552,
            "y": 552,
            "display": "is-visible",
            "tileSetId": "tileSet7"
          }
        ]
      },
      {
        "name": "tileset 2",
        "imagePath": "../../images/tiles_2.png",
        "cols": 6,
        "rows": 5,
        "tileOffset": 0,
        "tileOpacityColor": "255,255,255",
        "gameId": "game1",
        "id": "tileSet152",
        "img": {},
        "style": {},
        "tiles": [
          {
            "id": "tile153",
            "x": 0,
            "y": 0,
            "display": "is-visible",
            "tileSetId": "tileSet152"
          },
          {
            "id": "tile154",
            "x": 0,
            "y": 48,
            "display": "is-visible",
            "tileSetId": "tileSet152"
          },
          {
            "id": "tile155",
            "x": 0,
            "y": 96,
            "display": "is-visible",
            "tileSetId": "tileSet152"
          },
          {
            "id": "tile156",
            "x": 0,
            "y": 144,
            "display": "is-visible",
            "tileSetId": "tileSet152"
          },
          {
            "id": "tile157",
            "x": 0,
            "y": 192,
            "display": "is-visible",
            "tileSetId": "tileSet152"
          },
          {
            "id": "tile158",
            "x": 48,
            "y": 0,
            "display": "is-visible",
            "tileSetId": "tileSet152"
          },
          {
            "id": "tile159",
            "x": 48,
            "y": 48,
            "display": "is-visible",
            "tileSetId": "tileSet152"
          },
          {
            "id": "tile160",
            "x": 48,
            "y": 96,
            "display": "is-visible",
            "tileSetId": "tileSet152"
          },
          {
            "id": "tile161",
            "x": 48,
            "y": 144,
            "display": "is-visible",
            "tileSetId": "tileSet152"
          },
          {
            "id": "tile162",
            "x": 48,
            "y": 192,
            "display": "is-visible",
            "tileSetId": "tileSet152"
          },
          {
            "id": "tile163",
            "x": 96,
            "y": 0,
            "display": "is-visible",
            "tileSetId": "tileSet152"
          },
          {
            "id": "tile164",
            "x": 96,
            "y": 48,
            "display": "is-visible",
            "tileSetId": "tileSet152"
          },
          {
            "id": "tile165",
            "x": 96,
            "y": 96,
            "display": "is-visible",
            "tileSetId": "tileSet152"
          },
          {
            "id": "tile166",
            "x": 96,
            "y": 144,
            "display": "is-visible",
            "tileSetId": "tileSet152"
          },
          {
            "id": "tile167",
            "x": 96,
            "y": 192,
            "display": "is-visible",
            "tileSetId": "tileSet152"
          },
          {
            "id": "tile168",
            "x": 144,
            "y": 0,
            "display": "is-visible",
            "tileSetId": "tileSet152"
          },
          {
            "id": "tile169",
            "x": 144,
            "y": 48,
            "display": "is-visible",
            "tileSetId": "tileSet152"
          },
          {
            "id": "tile170",
            "x": 144,
            "y": 96,
            "display": "is-visible",
            "tileSetId": "tileSet152"
          },
          {
            "id": "tile171",
            "x": 144,
            "y": 144,
            "display": "is-visible",
            "tileSetId": "tileSet152"
          },
          {
            "id": "tile172",
            "x": 144,
            "y": 192,
            "display": "is-visible",
            "tileSetId": "tileSet152"
          },
          {
            "id": "tile173",
            "x": 192,
            "y": 0,
            "display": "is-visible",
            "tileSetId": "tileSet152"
          },
          {
            "id": "tile174",
            "x": 192,
            "y": 48,
            "display": "is-visible",
            "tileSetId": "tileSet152"
          },
          {
            "id": "tile175",
            "x": 192,
            "y": 96,
            "display": "is-visible",
            "tileSetId": "tileSet152"
          },
          {
            "id": "tile176",
            "x": 192,
            "y": 144,
            "display": "is-visible",
            "tileSetId": "tileSet152"
          },
          {
            "id": "tile177",
            "x": 192,
            "y": 192,
            "display": "is-visible",
            "tileSetId": "tileSet152"
          },
          {
            "id": "tile178",
            "x": 240,
            "y": 0,
            "display": "is-visible",
            "tileSetId": "tileSet152"
          },
          {
            "id": "tile179",
            "x": 240,
            "y": 48,
            "display": "is-visible",
            "tileSetId": "tileSet152"
          },
          {
            "id": "tile180",
            "x": 240,
            "y": 96,
            "display": "is-visible",
            "tileSetId": "tileSet152"
          },
          {
            "id": "tile181",
            "x": 240,
            "y": 144,
            "display": "is-visible",
            "tileSetId": "tileSet152"
          },
          {
            "id": "tile182",
            "x": 240,
            "y": 192,
            "display": "is-visible",
            "tileSetId": "tileSet152"
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
        "y": -48,
        "display": "is-visible",
        "tileSetId": "tileSet2",
        "id": "tile4"
      },
      {
        "x": -48,
        "y": 0,
        "display": "is-visible",
        "tileSetId": "tileSet2",
        "id": "tile5"
      },
      {
        "x": -48,
        "y": -48,
        "display": "is-visible",
        "tileSetId": "tileSet2",
        "id": "tile6"
      },
      {
        "x": 2,
        "y": 2,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile8"
      },
      {
        "x": 2,
        "y": 52,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile9"
      },
      {
        "x": 2,
        "y": 102,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile10"
      },
      {
        "x": 2,
        "y": 152,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile11"
      },
      {
        "x": 2,
        "y": 202,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile12"
      },
      {
        "x": 2,
        "y": 252,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile13"
      },
      {
        "x": 2,
        "y": 302,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile14"
      },
      {
        "x": 2,
        "y": 352,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile15"
      },
      {
        "x": 2,
        "y": 402,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile16"
      },
      {
        "x": 2,
        "y": 452,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile17"
      },
      {
        "x": 2,
        "y": 502,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile18"
      },
      {
        "x": 2,
        "y": 552,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile19"
      },
      {
        "x": 52,
        "y": 2,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile20"
      },
      {
        "x": 52,
        "y": 52,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile21"
      },
      {
        "x": 52,
        "y": 102,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile22"
      },
      {
        "x": 52,
        "y": 152,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile23"
      },
      {
        "x": 52,
        "y": 202,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile24"
      },
      {
        "x": 52,
        "y": 252,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile25"
      },
      {
        "x": 52,
        "y": 302,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile26"
      },
      {
        "x": 52,
        "y": 352,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile27"
      },
      {
        "x": 52,
        "y": 402,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile28"
      },
      {
        "x": 52,
        "y": 452,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile29"
      },
      {
        "x": 52,
        "y": 502,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile30"
      },
      {
        "x": 52,
        "y": 552,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile31"
      },
      {
        "x": 102,
        "y": 2,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile32"
      },
      {
        "x": 102,
        "y": 52,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile33"
      },
      {
        "x": 102,
        "y": 102,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile34"
      },
      {
        "x": 102,
        "y": 152,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile35"
      },
      {
        "x": 102,
        "y": 202,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile36"
      },
      {
        "x": 102,
        "y": 252,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile37"
      },
      {
        "x": 102,
        "y": 302,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile38"
      },
      {
        "x": 102,
        "y": 352,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile39"
      },
      {
        "x": 102,
        "y": 402,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile40"
      },
      {
        "x": 102,
        "y": 452,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile41"
      },
      {
        "x": 102,
        "y": 502,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile42"
      },
      {
        "x": 102,
        "y": 552,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile43"
      },
      {
        "x": 152,
        "y": 2,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile44"
      },
      {
        "x": 152,
        "y": 52,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile45"
      },
      {
        "x": 152,
        "y": 102,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile46"
      },
      {
        "x": 152,
        "y": 152,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile47"
      },
      {
        "x": 152,
        "y": 202,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile48"
      },
      {
        "x": 152,
        "y": 252,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile49"
      },
      {
        "x": 152,
        "y": 302,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile50"
      },
      {
        "x": 152,
        "y": 352,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile51"
      },
      {
        "x": 152,
        "y": 402,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile52"
      },
      {
        "x": 152,
        "y": 452,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile53"
      },
      {
        "x": 152,
        "y": 502,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile54"
      },
      {
        "x": 152,
        "y": 552,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile55"
      },
      {
        "x": 202,
        "y": 2,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile56"
      },
      {
        "x": 202,
        "y": 52,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile57"
      },
      {
        "x": 202,
        "y": 102,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile58"
      },
      {
        "x": 202,
        "y": 152,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile59"
      },
      {
        "x": 202,
        "y": 202,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile60"
      },
      {
        "x": 202,
        "y": 252,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile61"
      },
      {
        "x": 202,
        "y": 302,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile62"
      },
      {
        "x": 202,
        "y": 352,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile63"
      },
      {
        "x": 202,
        "y": 402,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile64"
      },
      {
        "x": 202,
        "y": 452,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile65"
      },
      {
        "x": 202,
        "y": 502,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile66"
      },
      {
        "x": 202,
        "y": 552,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile67"
      },
      {
        "x": 252,
        "y": 2,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile68"
      },
      {
        "x": 252,
        "y": 52,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile69"
      },
      {
        "x": 252,
        "y": 102,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile70"
      },
      {
        "x": 252,
        "y": 152,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile71"
      },
      {
        "x": 252,
        "y": 202,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile72"
      },
      {
        "x": 252,
        "y": 252,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile73"
      },
      {
        "x": 252,
        "y": 302,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile74"
      },
      {
        "x": 252,
        "y": 352,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile75"
      },
      {
        "x": 252,
        "y": 402,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile76"
      },
      {
        "x": 252,
        "y": 452,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile77"
      },
      {
        "x": 252,
        "y": 502,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile78"
      },
      {
        "x": 252,
        "y": 552,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile79"
      },
      {
        "x": 302,
        "y": 2,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile80"
      },
      {
        "x": 302,
        "y": 52,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile81"
      },
      {
        "x": 302,
        "y": 102,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile82"
      },
      {
        "x": 302,
        "y": 152,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile83"
      },
      {
        "x": 302,
        "y": 202,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile84"
      },
      {
        "x": 302,
        "y": 252,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile85"
      },
      {
        "x": 302,
        "y": 302,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile86"
      },
      {
        "x": 302,
        "y": 352,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile87"
      },
      {
        "x": 302,
        "y": 402,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile88"
      },
      {
        "x": 302,
        "y": 452,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile89"
      },
      {
        "x": 302,
        "y": 502,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile90"
      },
      {
        "x": 302,
        "y": 552,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile91"
      },
      {
        "x": 352,
        "y": 2,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile92"
      },
      {
        "x": 352,
        "y": 52,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile93"
      },
      {
        "x": 352,
        "y": 102,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile94"
      },
      {
        "x": 352,
        "y": 152,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile95"
      },
      {
        "x": 352,
        "y": 202,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile96"
      },
      {
        "x": 352,
        "y": 252,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile97"
      },
      {
        "x": 352,
        "y": 302,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile98"
      },
      {
        "x": 352,
        "y": 352,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile99"
      },
      {
        "x": 352,
        "y": 402,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile100"
      },
      {
        "x": 352,
        "y": 452,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile101"
      },
      {
        "x": 352,
        "y": 502,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile102"
      },
      {
        "x": 352,
        "y": 552,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile103"
      },
      {
        "x": 402,
        "y": 2,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile104"
      },
      {
        "x": 402,
        "y": 52,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile105"
      },
      {
        "x": 402,
        "y": 102,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile106"
      },
      {
        "x": 402,
        "y": 152,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile107"
      },
      {
        "x": 402,
        "y": 202,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile108"
      },
      {
        "x": 402,
        "y": 252,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile109"
      },
      {
        "x": 402,
        "y": 302,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile110"
      },
      {
        "x": 402,
        "y": 352,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile111"
      },
      {
        "x": 402,
        "y": 402,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile112"
      },
      {
        "x": 402,
        "y": 452,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile113"
      },
      {
        "x": 402,
        "y": 502,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile114"
      },
      {
        "x": 402,
        "y": 552,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile115"
      },
      {
        "x": 452,
        "y": 2,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile116"
      },
      {
        "x": 452,
        "y": 52,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile117"
      },
      {
        "x": 452,
        "y": 102,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile118"
      },
      {
        "x": 452,
        "y": 152,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile119"
      },
      {
        "x": 452,
        "y": 202,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile120"
      },
      {
        "x": 452,
        "y": 252,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile121"
      },
      {
        "x": 452,
        "y": 302,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile122"
      },
      {
        "x": 452,
        "y": 352,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile123"
      },
      {
        "x": 452,
        "y": 402,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile124"
      },
      {
        "x": 452,
        "y": 452,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile125"
      },
      {
        "x": 452,
        "y": 502,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile126"
      },
      {
        "x": 452,
        "y": 552,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile127"
      },
      {
        "x": 502,
        "y": 2,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile128"
      },
      {
        "x": 502,
        "y": 52,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile129"
      },
      {
        "x": 502,
        "y": 102,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile130"
      },
      {
        "x": 502,
        "y": 152,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile131"
      },
      {
        "x": 502,
        "y": 202,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile132"
      },
      {
        "x": 502,
        "y": 252,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile133"
      },
      {
        "x": 502,
        "y": 302,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile134"
      },
      {
        "x": 502,
        "y": 352,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile135"
      },
      {
        "x": 502,
        "y": 402,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile136"
      },
      {
        "x": 502,
        "y": 452,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile137"
      },
      {
        "x": 502,
        "y": 502,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile138"
      },
      {
        "x": 502,
        "y": 552,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile139"
      },
      {
        "x": 552,
        "y": 2,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile140"
      },
      {
        "x": 552,
        "y": 52,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile141"
      },
      {
        "x": 552,
        "y": 102,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile142"
      },
      {
        "x": 552,
        "y": 152,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile143"
      },
      {
        "x": 552,
        "y": 202,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile144"
      },
      {
        "x": 552,
        "y": 252,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile145"
      },
      {
        "x": 552,
        "y": 302,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile146"
      },
      {
        "x": 552,
        "y": 352,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile147"
      },
      {
        "x": 552,
        "y": 402,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile148"
      },
      {
        "x": 552,
        "y": 452,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile149"
      },
      {
        "x": 552,
        "y": 502,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile150"
      },
      {
        "x": 552,
        "y": 552,
        "display": "is-visible",
        "tileSetId": "tileSet7",
        "id": "tile151"
      },
      {
        "x": 0,
        "y": 0,
        "display": "is-visible",
        "tileSetId": "tileSet152",
        "id": "tile153"
      },
      {
        "x": 0,
        "y": 48,
        "display": "is-visible",
        "tileSetId": "tileSet152",
        "id": "tile154"
      },
      {
        "x": 0,
        "y": 96,
        "display": "is-visible",
        "tileSetId": "tileSet152",
        "id": "tile155"
      },
      {
        "x": 0,
        "y": 144,
        "display": "is-visible",
        "tileSetId": "tileSet152",
        "id": "tile156"
      },
      {
        "x": 0,
        "y": 192,
        "display": "is-visible",
        "tileSetId": "tileSet152",
        "id": "tile157"
      },
      {
        "x": 48,
        "y": 0,
        "display": "is-visible",
        "tileSetId": "tileSet152",
        "id": "tile158"
      },
      {
        "x": 48,
        "y": 48,
        "display": "is-visible",
        "tileSetId": "tileSet152",
        "id": "tile159"
      },
      {
        "x": 48,
        "y": 96,
        "display": "is-visible",
        "tileSetId": "tileSet152",
        "id": "tile160"
      },
      {
        "x": 48,
        "y": 144,
        "display": "is-visible",
        "tileSetId": "tileSet152",
        "id": "tile161"
      },
      {
        "x": 48,
        "y": 192,
        "display": "is-visible",
        "tileSetId": "tileSet152",
        "id": "tile162"
      },
      {
        "x": 96,
        "y": 0,
        "display": "is-visible",
        "tileSetId": "tileSet152",
        "id": "tile163"
      },
      {
        "x": 96,
        "y": 48,
        "display": "is-visible",
        "tileSetId": "tileSet152",
        "id": "tile164"
      },
      {
        "x": 96,
        "y": 96,
        "display": "is-visible",
        "tileSetId": "tileSet152",
        "id": "tile165"
      },
      {
        "x": 96,
        "y": 144,
        "display": "is-visible",
        "tileSetId": "tileSet152",
        "id": "tile166"
      },
      {
        "x": 96,
        "y": 192,
        "display": "is-visible",
        "tileSetId": "tileSet152",
        "id": "tile167"
      },
      {
        "x": 144,
        "y": 0,
        "display": "is-visible",
        "tileSetId": "tileSet152",
        "id": "tile168"
      },
      {
        "x": 144,
        "y": 48,
        "display": "is-visible",
        "tileSetId": "tileSet152",
        "id": "tile169"
      },
      {
        "x": 144,
        "y": 96,
        "display": "is-visible",
        "tileSetId": "tileSet152",
        "id": "tile170"
      },
      {
        "x": 144,
        "y": 144,
        "display": "is-visible",
        "tileSetId": "tileSet152",
        "id": "tile171"
      },
      {
        "x": 144,
        "y": 192,
        "display": "is-visible",
        "tileSetId": "tileSet152",
        "id": "tile172"
      },
      {
        "x": 192,
        "y": 0,
        "display": "is-visible",
        "tileSetId": "tileSet152",
        "id": "tile173"
      },
      {
        "x": 192,
        "y": 48,
        "display": "is-visible",
        "tileSetId": "tileSet152",
        "id": "tile174"
      },
      {
        "x": 192,
        "y": 96,
        "display": "is-visible",
        "tileSetId": "tileSet152",
        "id": "tile175"
      },
      {
        "x": 192,
        "y": 144,
        "display": "is-visible",
        "tileSetId": "tileSet152",
        "id": "tile176"
      },
      {
        "x": 192,
        "y": 192,
        "display": "is-visible",
        "tileSetId": "tileSet152",
        "id": "tile177"
      },
      {
        "x": 240,
        "y": 0,
        "display": "is-visible",
        "tileSetId": "tileSet152",
        "id": "tile178"
      },
      {
        "x": 240,
        "y": 48,
        "display": "is-visible",
        "tileSetId": "tileSet152",
        "id": "tile179"
      },
      {
        "x": 240,
        "y": 96,
        "display": "is-visible",
        "tileSetId": "tileSet152",
        "id": "tile180"
      },
      {
        "x": 240,
        "y": 144,
        "display": "is-visible",
        "tileSetId": "tileSet152",
        "id": "tile181"
      },
      {
        "x": 240,
        "y": 192,
        "display": "is-visible",
        "tileSetId": "tileSet152",
        "id": "tile182"
      }
    ],
    "Scene": [
      {
        "name": "last scene",
        "width": 5,
        "height": 5,
        "gameId": "game1",
        "id": "scene183"
      }
    ],
    "Layer": [
      {
        "name": "layer 7",
        "order": 1,
        "sceneId": "scene183",
        "id": "layer185"
      }
    ],
    "Cell": [
      {
        "col": 4,
        "row": 0,
        "tileId": "tile10",
        "chunkId": "chunk186",
        "id": "cell187"
      },
      {
        "col": 3,
        "row": 0,
        "tileId": "tile10",
        "chunkId": "chunk186",
        "id": "cell188"
      },
      {
        "col": 3,
        "row": 1,
        "tileId": "tile10",
        "chunkId": "chunk186",
        "id": "cell189"
      },
      {
        "col": 4,
        "row": 1,
        "tileId": "tile10",
        "chunkId": "chunk186",
        "id": "cell190"
      },
      {
        "col": 0,
        "row": 3,
        "tileId": "tile58",
        "chunkId": "chunk186",
        "id": "cell195"
      },
      {
        "col": 1,
        "row": 3,
        "tileId": "tile58",
        "chunkId": "chunk186",
        "id": "cell196"
      },
      {
        "col": 1,
        "row": 4,
        "tileId": "tile58",
        "chunkId": "chunk186",
        "id": "cell197"
      },
      {
        "col": 0,
        "row": 4,
        "tileId": "tile58",
        "chunkId": "chunk186",
        "id": "cell198"
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
