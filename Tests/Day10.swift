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
  
  func testPart1() {
    let challenge = Day10(data: testData)
    XCTAssertEqual(String(describing: challenge.part1()), "8")
  }
  
}
