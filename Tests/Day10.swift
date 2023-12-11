import Foundation
import XCTest
@testable import AdventOfCode

final class Day10Tests: XCTestCase {

  let testData = """
    ..F7.
    .FJ|.
    SJ.L7
    |F--J
    LJ...
    """
  
  let testDataPart2 = """
    FF7FSF7F7F7F7F7F---7
    L|LJ||||||||||||F--J
    FL-7LJLJ||||||LJL-77
    F--JF--7||LJLJIF7FJ-
    L---JF-JLJIIIIFJLJJ7
    |F|F-JF---7IIIL7L|7|
    |FFJF7L7F-JF7IIL---7
    7-L-JL7||F7|L7F-7F7|
    L.L7LFJ|||||FJL7||LJ
    L7JLJL-JLJLJL--JLJ.L
    """
  
  func testPart1() {
    let challenge = Day10(data: testData)
    XCTAssertEqual(String(describing: challenge.part1()), "8")
  }
  
  func testPart2() {
    let challenge = Day10(data: testDataPart2)
    XCTAssertEqual(String(describing: challenge.part2()), "10")
  }
}
