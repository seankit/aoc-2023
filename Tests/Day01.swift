import Foundation
import XCTest

@testable import AdventOfCode

final class Day01Tests: XCTestCase {

  let testData = """
    1abc2
    pqr3stu8vwx
    a1b2c3d4e5f
    treb7uchet
    """

  let testDataPart2 = """
    two1nine
    eightwothree
    abcone2threexyz
    xtwone3four
    4nineeightseven2
    zoneight234
    7pqrstsixteen
    """

  func testPart1() {
    let challenge = Day01(data: testData)
    XCTAssertEqual(String(describing: challenge.part1()), "142")
  }

  func testPart2() {
    let challenge = Day01(data: testDataPart2)
    XCTAssertEqual(String(describing: challenge.part2()), "281")
  }
}
