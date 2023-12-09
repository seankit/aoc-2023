
struct Day09: AdventDay {
  let data: String
  var lines: [Substring] { data.split(whereSeparator: \.isNewline) }
  var histories: [[Int]] { lines.map { $0.split(separator: " ").compactMap { Int($0) } } }

  func part1() -> Any {
    histories.map { extrapolateForward($0) }.reduce(0, +)
  }
  
  func part2() -> Any {
    histories.map { extrapolateBackward($0) }.reduce(0, +)
  }
  
  func differences(_ list: [Int]) -> [Int] {
    var differences: [Int] = []
    for (i, value) in list.enumerated() {
      guard i > 0 else { continue }
      differences.append(value - list[i - 1])
    }
    return differences
  }
  
  func extrapolateForward(_ list: [Int]) -> Int {
    list.allSatisfy({ $0 == 0 }) ? 0 : (list.last! + extrapolateForward(differences(list)))
  }
  
  func extrapolateBackward(_ list: [Int]) -> Int {
    list.allSatisfy({ $0 == 0 }) ? 0 : (list.first! - extrapolateBackward(differences(list)))
  }
}
