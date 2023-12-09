import Foundation
import RegexBuilder

struct Day08: AdventDay {
  let data: String
  let directions: [Character]
  let nodeMap: [Substring: (left: Substring, right: Substring)]
  
  init(data: String) {
    self.data = data
    let lines = data.split(whereSeparator: \.isNewline)
    self.directions = lines.first?.compactMap { $0 } ?? []
    let nodeLines = data.split(separator: "\n\n").last?.split(whereSeparator: \.isNewline) ?? []
    self.nodeMap = Day08.makeNodeMap(lines: nodeLines)
  }
    
  func part1() -> Any {
    return navigate(index: 0, startingNode: "AAA", count: 0, foundEnd: { $0 == "ZZZ" })
  }
  
  func part2() -> Any {
    let startingNodes = nodeMap.keys.filter { $0.hasSuffix("A") }
    let counts = startingNodes.map {
      navigate(index: 0, startingNode: $0, count: 0, foundEnd: { $0.hasSuffix("Z") })
    }
    return counts.reduce(1) { lcm($0, $1) }
  }
  
  func gcd(_ a: Int, _ b: Int) -> Int {
    let r = a % b
    return r != 0 ? gcd(b, r) : b
  }
  
  func lcm(_ a: Int, _ b: Int) -> Int {
    return a / gcd(a, b) * b
  }
  
  func navigate(index: Int, startingNode: Substring, count: Int, foundEnd: (Substring) -> Bool ) -> Int {
    var current = startingNode
    var index = 0
    var count = 0
    while !foundEnd(current) {
      let direction = directions[index % directions.count]
      guard let next = direction == "L" ? nodeMap[current]?.left : nodeMap[current]?.right else { continue }
      current = next
      index += 1
      count += 1
    }
    return count
  }
  
  private static func makeNodeMap(lines: [Substring]) -> [Substring: (left: Substring, right: Substring)] {
    let keyRef = Reference(Substring.self)
    let leftRef = Reference(Substring.self)
    let rightRef = Reference(Substring.self)
    
    let search = Regex {
      Capture(as: keyRef) {
        OneOrMore(.word)
      }
      
      " = ("
      
      Capture(as: leftRef) {
        OneOrMore(.word)
      }
      
      ", "
      
      Capture(as: rightRef) {
        OneOrMore(.word)
      }
      
      ")"
    }
    
    var map: [Substring: (left: Substring, right: Substring)] = [:]
    for line in lines {
      guard let values = line.firstMatch(of: search) else { continue }
      map[values[keyRef]] = (left: values[leftRef], right: values[rightRef])
    }
    return map
  }
}
