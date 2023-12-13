import Foundation
import XCTest
@testable import AdventOfCode

final class Day11Tests: XCTestCase {

  let testData = """
    ...#......
    .......#..
    #.........
    ..........
    ......#...
    .#........
    .........#
    ..........
    .......#..
    #...#.....
    """

  func testPart1() {
    let challenge = Day11(data: testData)
    XCTAssertEqual(String(describing: challenge.part1()), "374")
  }
}
