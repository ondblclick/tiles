class @TileCommon extends Model
  handleClick: ->
    neighbors = @neighbors()
    allowedTypes = Object.keys(Tile.types)
    allowedTypes = allowedTypes.filter (type) ->
      for key, value of Tile.inversed
        if neighbors[key]
          if Tile.types[neighbors[key].type][value].indexOf(type) is -1
            return false
      return true
    console.log allowedTypes

  emptyNeighbors: ->
    res = []
    n = @neighbors()
    res.push { x: @x, y: @y + 1 } unless n.bottom
    res.push { x: @x, y: @y - 1 } unless n.top
    res.push { x: @x + 1, y: @y } unless n.right
    res.push { x: @x - 1, y: @y } unless n.left
    res

  neighbors: ->
    res = {}
    positions =
      bottom: { x: @x, y: @y + 1 }
      top: { x: @x, y: @y - 1 }
      right: { x: @x + 1, y: @y }
      left: { x: @x - 1, y: @y }
    for position, coords of positions
      tile = Tile.findByPosition(coords)
      res[position] = tile if tile
    res
