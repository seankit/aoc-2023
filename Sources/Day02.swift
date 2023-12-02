//
//  File.swift
//  
//
//  Created by Sean Kelly on 12/2/23.
//

import Foundation

struct Day02: AdventDay {
    var data: String
    
    var lines: [Substring] { data.split(whereSeparator: \.isNewline) }
    
    func part1() -> Any {
        
        var total = 0
        for line in lines {
            let rounds = line.split(separator: ":").last?.split(separator: ";") ?? []
            
            var validRound = true
            for round in rounds {
                let diceValues = round.split(separator: ",")
                
                for value in diceValues {
                    let split = value.split(separator: " ")
                    if split.last == "red", let first = split.first, let val = Int(first) {
                        validRound = val <= ColorMax.red.rawValue
                    }
                    else if split.last == "green", let first = split.first, let val = Int(first) {
                        validRound = val <= ColorMax.green.rawValue
                    }
                    else if split.last == "blue", let first = split.first, let val = Int(first) {
                        validRound = val <= ColorMax.blue.rawValue
                    }
                    if !validRound {
                        break
                    }
                }
                if !validRound {
                    break
                }
            }
            guard validRound else { continue }
            
            let gameID = line.split(separator: ":").first?.split(separator: " ").last ?? ""
            total += Int("\(gameID)") ?? 0
        }
        return total
    }
    
    func part2() -> Any {
        var total = 0
        for line in lines {
            let rounds = line.split(separator: ":").last?.split(separator: ";") ?? []
            
            var minRed = 1
            var minGreen = 1
            var minBlue = 1
            for round in rounds {
                let diceValues = round.split(separator: ",")
                
                for value in diceValues {
                    let split = value.split(separator: " ")
                    if split.last == "red", let first = split.first, let val = Int(first) {
                        minRed = max(minRed, val)
                    }
                    else if split.last == "green", let first = split.first, let val = Int(first) {
                        minGreen = max(minGreen, val)
                    }
                    else if split.last == "blue", let first = split.first, let val = Int(first) {
                        minBlue = max(minBlue, val)
                    }
                }
            }
            let power = minRed * minGreen * minBlue
            total += power
        }
        return total
    }
}

enum ColorMax: Int {
    case red = 12
    case green = 13
    case blue = 14
}
