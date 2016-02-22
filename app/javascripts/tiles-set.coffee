@tilesSet = {}
[0..11].forEach (col) ->
  [0..11].forEach (row) ->
    @tilesSet["#{col}-#{row}"] = {}
