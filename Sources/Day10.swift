
typealias Coordinate = (row: Int, column: Int)

struct Day10: AdventDay {
  let data: String
  var grid: [[Character]] { data.split(whereSeparator: \.isNewline).map { Array($0) } }
  
  enum Direction: String {
    case north
    case south
    case east
    case west
  }
  
  let validIn: [Character: Set<Direction>] = [
    "|": [.north, .south],
    "-": [.east, .west],
    "L": [.south, .west],
    "J": [.south, .east],
    "7": [.north, .east],
    "F": [.north, .west],
    ".": [],
  ]
  
  let validOut: [Character: Set<Direction>] = [
    "|": [.north, .south],
    "-": [.east, .west],
    "L": [.north, .east],
    "J": [.north, .west],
    "7": [.south, .west],
    "F": [.south, .east],
    "S": [.north, .south, .east, .west]
  ]
  
  let directionCoordinateMap: [Direction: Coordinate] = [
    .north: (-1, 0),
    .south: (1, 0),
    .east: (0, 1),
    .west: (0, -1)
  ]
  
  let verticalSet: Set<Character> = ["|", "J", "L", "S"]
  
  func part1() -> Any {
    var loopTiles = Set<[Int]>()

    return findLoop(loopTiles: &loopTiles)
  }
  
  func part2() -> Any {
    var loopTiles = Set<[Int]>()
    findLoop(loopTiles: &loopTiles)
    
    let fieldTiles = floodFill(loop: loopTiles)
    return findInsideTiles(loopTiles: loopTiles, fieldTiles: fieldTiles)
  }
  
  @discardableResult
  func findLoop(loopTiles: inout Set<[Int]>) -> Int {
    let grid = grid
    let numRows = grid.count
    let numColumns = grid[0].count
    
    var queue: [Coordinate] = []
    var visited: Set<[Int]> = []
    
    for row in 0..<numRows {
      for column in 0..<numColumns {
        guard grid[row][column] == "S" else { continue }
        queue.append((row, column))
        break
      }
    }
    
    var distance = 0
    while !queue.isEmpty {
      for _ in 0..<queue.count {
        let coordinate = queue.removeFirst()
        let pipe = grid[coordinate.row][coordinate.column]
        
        visited.insert([coordinate.row, coordinate.column])
        
        guard let outDirections = validOut[pipe] else { continue }
        
        for direction in outDirections {
          guard let outCoordinate = directionCoordinateMap[direction] else { continue }
          
          let row = coordinate.row + outCoordinate.row
          let column = coordinate.column + outCoordinate.column
          
          guard row >= 0, row <= numRows - 1,
                column >= 0, column <= numColumns - 1,
                !visited.contains([row, column])
          else { continue }
          
          let neighbor = grid[row][column]
          
          guard let neighborIn = validIn[neighbor],
                neighborIn.contains(direction) == true
          else { continue }
          
          queue.append((row, column))
          loopTiles.insert([row, column])
        }
      }
      distance += 1
    }
    return distance - 1
  }
  
  func floodFill(loop: Set<[Int]>) -> Set<[Int]> {
    let grid = grid
    let numRows = grid.count
    let numColumns = grid[0].count
    
    var visited = Set<[Int]>()
    var starting: [Coordinate] = []
    
    for row in 0..<numRows {
      if !loop.contains([row, 0]) {
        starting.append((row, 0))
      }
      if !loop.contains([row, numColumns - 1]) {
        starting.append((row, numColumns - 1))
      }
    }
    
    for column in 0..<numColumns {
      if !loop.contains([0, column]) {
        starting.append((0, column))
      }
      if !loop.contains([numRows - 1, column]) {
        starting.append((numRows - 1, column))
      }
    }
    
    for coordinate in starting {
      guard !visited.contains([coordinate.row, coordinate.column]) else { continue }
      
      var stack: [Coordinate] = [coordinate]
      
      while !stack.isEmpty {
        let coordinate = stack.removeLast()
        let row = coordinate.row
        let column = coordinate.column
        
        guard row >= 0, row <= numRows - 1,
              column >= 0, column <= numColumns - 1,
              grid[row][column] != "0",
              !loop.contains([row, column]),
              !visited.contains([row, column])
        else { continue }
        
        visited.insert([row, column])
        stack.append((row - 1, column))
        stack.append((row + 1, column))
        stack.append((row, column - 1))
        stack.append((row, column + 1))
      }
    }
    
    return visited
  }
  
  func findInsideTiles(loopTiles: Set<[Int]>, fieldTiles: Set<[Int]>) -> Int {
    let grid = grid
    let numRows = grid.count
    let numColumns = grid[0].count
    
    var insideCount = 0
    for row in 0..<numRows {
      for column in 0..<numColumns {
        guard !loopTiles.contains([row, column]),
              !fieldTiles.contains([row, column]),
              isInsideTile(charsToLeft: Array(grid[row][0..<column]), row: row, loopTiles: loopTiles)
        else { continue }
        insideCount += 1
      }
    }
    return insideCount
  }
  
  func isInsideTile(charsToLeft: [Character], row: Int, loopTiles: Set<[Int]>) -> Bool {
    var numVerticals = 0
    for (i, character) in charsToLeft.enumerated() {
      guard loopTiles.contains([row, i]),
            verticalSet.contains(character)
      else { continue }
      
      numVerticals += 1
    }
    return numVerticals % 2 == 1
  }
}

