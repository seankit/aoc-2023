
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
  
  func part1() -> Any {
    let grid = grid
    
    let numRows = grid.count
    let numColumns = grid[0].count
    
    var queue: [Coordinate] = []
    var visited = Set<[Int]>()
    
    for row in 0..<numRows {
      for column in 0..<numColumns {
        guard grid[row][column] == "S" else { continue }
        queue.append((row, column))
      }
    }
    
    var distance = 0
    while !queue.isEmpty {
      for _ in 0..<queue.count {
        let coordinate = queue.removeFirst()
        let pipe = grid[coordinate.row][coordinate.column]
        
        visited.insert([coordinate.row, coordinate.column])
        
        guard let validOut = validOut[pipe] else { continue }
        
        for direction in validOut {
          guard let outCoordinate = directionCoordinateMap[direction] else { continue }
          
          let row = coordinate.row + outCoordinate.row
          let column = coordinate.column + outCoordinate.column
          
          guard row >= 0, row <= numRows - 1,
                column >= 0, column <= numColumns - 1,
                grid[row][column] != ".",
                !visited.contains([row, column])
          else { continue }
          
          let neighborPipe = grid[row][column]
          
          guard let neighborIn = validIn[neighborPipe],
                neighborIn.contains(direction) == true else { continue }
          
          queue.append((row, column))
        }
      }
      distance += 1
    }
    return distance - 1
  }
}
