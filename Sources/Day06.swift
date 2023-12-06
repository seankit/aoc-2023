//
//  File.swift
//  
//
//  Created by Sean Kelly on 12/5/23.
//

import Foundation

struct Day06: AdventDay {
    let data: String

    func part1() -> Any {
        let lines = data.split(whereSeparator: \.isNewline)
        let values = lines.compactMap { $0.split(separator: ":").last }.map { $0.split{ $0 == " " }.compactMap { Int($0) } }
        let times = values[0]
        let distances = values[1]
        
        var counts: [Int] = []
        for (index, time) in times.enumerated() {
            let distance = distances[index]
            var counter = time
            var options = 0
            while counter >= 0 {
                if counter * (time - counter) > distance {
                    options += 1
                }
                counter -= 1
            }
            counts.append(options)
        }
        return counts.reduce(1, *)
    }
    
    func part2() -> Any {
        let lines = data.split(whereSeparator: \.isNewline)
        let values = lines.compactMap { $0.split(separator: ":").last?.filter { !$0.isWhitespace } }.compactMap { Int($0) }
        let time = values[0]
        let distance = values[1]
        
        var counter = time
        var options = 0
        while counter >= 0 {
            if counter * (time - counter) > distance {
                options += 1
            }
            counter -= 1
        }
        return options
    }
}
