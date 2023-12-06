//
//  File.swift
//  
//
//  Created by Sean Kelly on 12/5/23.
//

import Foundation

struct Day06: AdventDay {
    let data: String
    var lines: [Substring] {
        data.split(whereSeparator: \.isNewline)
    }

    func part1() -> Any {
        let values = lines.compactMap { $0.split(separator: ":").last }.map { $0.split{ $0 == " " }.compactMap { Int($0) } }
        let times = values[0]
        let distances = values[1]
        
        return zip(times, distances).map { calculate(time: $0, distance: $1) }.reduce(1, *)
    }
    
    func part2() -> Any {
        let values = lines.compactMap { $0.split(separator: ":").last?.filter { !$0.isWhitespace } }.compactMap { Int($0) }
        let time = values[0]
        let distance = values[1]
        
        return calculate(time: time, distance: distance)
    }
    
    func calculate(time: Int, distance: Int) -> Int {
        var counter = time
        var wins = 0
        while counter >= 0 {
            if counter * (time - counter) > distance {
                wins += 1
            }
            counter -= 1
        }
        return wins
    }
}
