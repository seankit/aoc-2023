
fileprivate typealias Coordinate = (row: Int, column: Int)

struct Day11: AdventDay {
  let data: String
  let grid: [[Character]]
  private let galaxyLocations: [Coordinate]
  let emptyRows: [Int]
  let emptyColumns: [Int]
  
  var numRows: Int { grid.count }
  var numColumns: Int { grid[0].count }
  
  init(data: String) {
    self.data = data
    self.grid = data.split(whereSeparator: \.isNewline).map { Array($0) }
    
    let grid = grid
    let numRows = grid.count
    let numColumns = grid[0].count
    
    var locations: [Coordinate] = []
    for row in 0..<numRows {
      for column in 0..<numColumns {
        guard grid[row][column] == "#" else { continue }
        locations.append((row, column))
      }
    }
    self.galaxyLocations = locations
    
    var rows: [Int] = []
    for i in 0..<numRows {
      let row = grid[i]
      if row.allSatisfy({ $0 == "." }) {
        rows.append(i)
      }
    }
    self.emptyRows = rows
    
    var columns: [Int] = []
    for i in 0..<numColumns {
      let column = grid.map { $0[i] }
      if column.allSatisfy({ $0 == "." }) {
        columns.append(i)
      }
    }
    self.emptyColumns = columns
  }
  
  //bfs
  func part1() -> Any {
    let galaxyLocations = galaxyLocations
    var pairs: [(Coordinate, Coordinate)] = []
    for (index, galaxyLocation) in galaxyLocations.enumerated() {
      for nextLocation in galaxyLocations[(index + 1)...] {
        pairs.append((galaxyLocation, nextLocation))
      }
    }
    
    let numRows = numRows
    let numColumns = numColumns
    
    var emptyRows: Set<Int> = []
    for i in 0..<numRows {
      let row = grid[i]
      if row.allSatisfy({ $0 == "." }) {
        emptyRows.insert(i)
      }
    }
    
    var emptyColumns: Set<Int> = []
    for i in 0..<numColumns {
      let column = grid.map { $0[i] }
      if column.allSatisfy({ $0 == "." }) {
        emptyColumns.insert(i)
      }
    }
    
    var shortestDistances: [Int] = []
    
    for pair in pairs {
      let ax = min(pair.0.row, pair.1.row)
      let bx = max(pair.0.row, pair.1.row)
      let ay = min(pair.0.column, pair.1.column)
      let by = max(pair.0.column, pair.1.column)
      
      var distance = (bx - ax) + emptyRows.intersection(Set(ax..<bx + 1)).count
      distance += (by - ay) + emptyColumns.intersection(Set(ay..<by + 1)).count
      shortestDistances.append(distance)
    }
    
    return shortestDistances.reduce(0, +)
  }
  
  func part2() -> Any {
    let galaxyLocations = galaxyLocations
    var pairs: [(Coordinate, Coordinate)] = []
    for (index, galaxyLocation) in galaxyLocations.enumerated() {
      for nextLocation in galaxyLocations[(index + 1)...] {
        pairs.append((galaxyLocation, nextLocation))
      }
    }
    
    let numRows = numRows
    let numColumns = numColumns
    
    var emptyRows: Set<Int> = []
    for i in 0..<numRows {
      let row = grid[i]
      if row.allSatisfy({ $0 == "." }) {
        emptyRows.insert(i)
      }
    }
    
    var emptyColumns: Set<Int> = []
    for i in 0..<numColumns {
      let column = grid.map { $0[i] }
      if column.allSatisfy({ $0 == "." }) {
        emptyColumns.insert(i)
      }
    }
    
    var shortestDistances: [Int] = []
    
    for pair in pairs {
      let ax = min(pair.0.row, pair.1.row)
      let bx = max(pair.0.row, pair.1.row)
      let ay = min(pair.0.column, pair.1.column)
      let by = max(pair.0.column, pair.1.column)
      
      var distance = (bx - ax) + (emptyRows.intersection(Set(ax..<bx)).count * (1000000 - 1))
      distance += (by - ay) + (emptyColumns.intersection(Set(ay..<by)).count * (1000000 - 1))
      shortestDistances.append(distance)
    }
    
    return shortestDistances.reduce(0, +)
  }
}
