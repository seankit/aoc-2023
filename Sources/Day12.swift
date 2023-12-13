
struct Day12: AdventDay {
  let data: String
  var lines: [Substring] { data.split(whereSeparator: \.isNewline) }
  var springs: [(spring: [Character], groups: [Int])] {
    let components = lines.map { $0.split(separator: " ") }
    return lines.map { $0.split(separator: " ") }.map { parts in
      (Array(parts[0]), parts[1].split(separator: ",").compactMap { Int($0) } )
    }
  }
  
  func part1() -> Any {
    var sum  = 0
    for var (spring, groups) in springs {
      let total = backtrack(spring: &spring, groups: groups, index: 0)
      sum += total
    }
    return sum
  }
  
  func backtrack(spring: inout [Character], groups: [Int], index: Int) -> Int {
    guard index < spring.count else {
      return blocks(in: spring) == groups ? 1 : 0
    }
    guard spring[index] == "?" else {
      return backtrack(spring: &spring, groups: groups, index: index + 1)
    }
    
    var broken = spring
    var operational = spring
    broken[index] = "#"
    operational[index] = "."
    return backtrack(spring: &broken, groups: groups, index: index + 1) + backtrack(spring: &operational, groups: groups, index: index + 1)
  }
  
  func blocks(in spring: [Character]) -> [Int] {
    var groups: [Int] = []
    var currentGroup = 0
    for character in spring {
      if character == "." {
        if currentGroup > 0 {
          groups.append(currentGroup)
        }
        currentGroup = 0
      } else if character == "#" {
        currentGroup += 1
      }
    }
    
    if currentGroup > 0 {
      groups.append(currentGroup)
    }
    return groups
  }
}
