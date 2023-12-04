//
//  File.swift
//  
//
//  Created by Sean Kelly on 12/3/23.
//

import Foundation
import XCTest
@testable import AdventOfCode

final class Day03Tests: XCTestCase {
    
    let testData = """
        467..114..
        ...*......
        ..35..633.
        ......#...
        617*......
        .....+.58.
        ..592.....
        ......755.
        ...$.*....
        .664.598..
        """
    
    func testPart1() {
        let challenge = Day03(data: testData)
        XCTAssertEqual(String(describing: challenge.part1()), "4361")
    }
    
    func testPart2() {
        let challenge = Day03(data: testData)
        XCTAssertEqual(String(describing: challenge.part2()), "467835")
    }
}
