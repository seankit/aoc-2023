//
//  File.swift
//  
//
//  Created by Sean Kelly on 12/4/23.
//

import Foundation

struct Day05: AdventDay {
    let data: String
    
    let seeds: [Int]
    let seedRanges: [Range<Int>]
    let maps: [[Range<Int>: Range<Int>]]
        
    init(data: String) {
        self.data = data
        var lines = data.split(separator: "\n\n")
        
        let values = lines.removeFirst().split(separator: ":").last?.split(separator: " ").compactMap { Int($0) } ?? []
        self.seeds = values
        
        var ranges: [Range<Int>] = []
        for i in stride(from: 0, to: values.count, by: 2) {
            let range = values[i]..<values[i]+values[i+1]
            ranges.append(range)
        }
        self.seedRanges = ranges
        
        self.maps = lines.map { line in
            var map: [Range<Int>: Range<Int>] = [:]
            let valueLines = line.split(separator: "\n").dropFirst()
            
            for valueLine in valueLines {
                let values = valueLine.split(separator: " ").compactMap { Int($0) }
                guard let rangeLength = values.last else { continue }
                
                let sourceRange = values[1]..<values[1]+rangeLength
                let destinationRange = values[0]..<values[0]+rangeLength
                map[sourceRange] = destinationRange
            }
            return map
        }
    }
    
    func part1() -> Any {
        return seeds.compactMap { site(for: $0, mapIndex: 0) }.min() ?? 0
    }
    
    func part2() -> Any {
        var best: Int = .max
        for range in seedRanges {
            var left = range.lowerBound
            var right = range.upperBound
            
            var lowest: Int = .max
            while left < right {
                let seed = (left + right) / 2
                let site = site(for: seed, mapIndex: 0)
                if site < lowest {
                    lowest = site
                    right = seed - 1
                } else {
                    left = seed + 1
                }
            }
            best = min(best, lowest)
        }
        return best
    }
    
    private func site(for value: Int, mapIndex: Int) -> Int {
        guard let range = maps[mapIndex].filter({ $0.key.contains(value) }).first,
              range.key.contains(value)
        else {
            return mapIndex == maps.count - 1 ? value : site(for: value, mapIndex: mapIndex + 1)
        }

        let sourceRange = range.key
        let difference = value - sourceRange.lowerBound

        let destinationRange = range.value
        let destinationValue = destinationRange.lowerBound + difference
        
        return mapIndex == maps.count - 1 ? destinationValue : site(for: destinationValue, mapIndex: mapIndex + 1)
    }
}
