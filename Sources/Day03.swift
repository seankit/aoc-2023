//
//  File.swift
//  
//
//  Created by Sean Kelly on 12/3/23.
//

import Foundation

struct Day03: AdventDay {
    var data: String
    
    var grid: [[Character]] {
        data.split(whereSeparator: \.isNewline).map { Array($0) }
    }
    
    private let coordinates = [(row: -1, column: -1), (row: 0, column: -1), (row: 1, column: -1),
                               (row: -1, column: 0), (row: 1, column: 0),
                               (row: -1, column: 1), (row: 0, column: 1), (row: 1, column: 1)]
    
    private let symbols: Set<Character> = ["#", "=", "+", "/", "$", "*", "&", "-", "%", "@"]
    private let star: Set<Character> = ["*"]

    func part1() -> Any {
        var partNumbers: [Int] = []
        findAdjacentValues(of: symbols) { adjacent in
            partNumbers.append(contentsOf: adjacent)
        }
        
        return partNumbers.reduce(0, +)
    }
    
    func part2() -> Any {
        var gearRatios: [Int] = []
        findAdjacentValues(of: star) { adjacent in
            guard adjacent.count == 2 else { return }
            gearRatios.append(adjacent.reduce(1, *))
        }
        
        return gearRatios.reduce(0, +)
    }
    
    // MARK: Private
    
    private func findAdjacentValues(of set: Set<Character>, found: @escaping ([Int]) -> Void) {
        var grid = grid
        
        let numRows = grid.count
        let numColumns = grid[0].count
        
        for row in 0..<numRows {
            for column in 0..<numColumns {
                guard set.contains(grid[row][column]) else { continue }
                
                var adjacent: [Int] = []
                for coordinate in coordinates {
                    guard row + coordinate.row >= 0, row + coordinate.row <= numRows - 1,
                          column + coordinate.column >= 0, column + coordinate.column < numColumns - 1,
                          grid[row + coordinate.row][column + coordinate.column].isNumber else { continue }
                    
                    let numberRange = numberRange(in: grid[row + coordinate.row], at: column + coordinate.column)
                    let number = Array(grid[row + coordinate.row][numberRange]).map { String($0) }.joined()
                    guard let partNumber = Int(number) else { continue }
                    
                    let replacement: [Character] = numberRange.map { _ in "." }
                    grid[row + coordinate.row].replaceSubrange(numberRange, with: replacement)
                    
                    adjacent.append(partNumber)
                }
                found(adjacent)
            }
        }
    }
    
    private func numberRange(in row: [Character], at column: Int) -> ClosedRange<Int> {
        var lowerBound = column
        var upperBound = column
        
        while upperBound < row.count - 1, row[upperBound + 1].isNumber {
            upperBound += 1
        }
        while lowerBound > 0, row[lowerBound - 1].isNumber {
            lowerBound -= 1
        }
        return lowerBound...upperBound
    }
}
