//
//  File.swift
//  
//
//  Created by Sean Kelly on 12/1/23.
//

import Foundation

struct Day01: AdventDay {
    var data: String
    
    var entities: [String.SubSequence] {
        data.split(whereSeparator: \.isNewline)
    }
    
    func part1() -> Any {
        entities.map { Array($0).filter(\.isNumber) }.compactMap { Int("\($0[0])\($0[$0.count - 1])") }.reduce(0, +)
    }
    
    func part2() -> Any {
        let digits = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        
        return entities.map { line in
            var firstRange: Range<Substring.Index>?
            var lastRange: Range<Substring.Index>?
            
            for digit in digits {
                let ranges = line.ranges(of: digit)
                guard !ranges.isEmpty else { continue }
                
                firstRange = firstRange.map { $0.lowerBound < ranges.first!.lowerBound ? $0 : ranges.first } ?? ranges.first
                lastRange = lastRange.map { $0.lowerBound > ranges.last!.lowerBound ? $0 : ranges.last } ?? ranges.last
            }
            
            let firstDigit = String(line[firstRange!]).intValue
            let lastDigit = String(line[lastRange!]).intValue
            return Int("\(firstDigit!)\(lastDigit!)")!
        }.reduce(0, +)
    }
}

extension String {
    var intValue: Int? {
        guard let value = Int(self) else {
            let formatter = NumberFormatter()
            formatter.numberStyle = .spellOut
            return formatter.number(from: self) as? Int
        }
        return value
    }
}
