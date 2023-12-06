//
//  File.swift
//  
//
//  Created by Sean Kelly on 12/5/23.
//

import Foundation
import XCTest
@testable import AdventOfCode

final class Day06Tests: XCTestCase {
    let testData = """
    Time:      7  15   30
    Distance:  9  40  200
    """
    
    func testPart1() {
        let challenge = Day06(data: testData)
        XCTAssertEqual(String(describing: challenge.part1()), "288")
    }
    
    func testPart2() {
        let challenge = Day06(data: testData)
        XCTAssertEqual(String(describing: challenge.part2()), "71503")
    }
}
