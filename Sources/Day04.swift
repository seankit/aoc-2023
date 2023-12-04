//
//  File.swift
//  
//
//  Created by Sean Kelly on 12/3/23.
//

import Foundation

struct Day04: AdventDay {
    let data: String
    
    var lines: [Substring] { data.split(whereSeparator: \.isNewline) }
    
    var scratchCards: [ScratchCard] {
        lines.compactMap { line in
            let split = line.split(separator: ":")
            guard let idString = split.first?.split(separator: " ").last,
                  let id = Int("\(idString)"),
                  let numberSets = split.last?.split(separator: "|"),
                  let winningNumbers = numberSets.first?.split(separator: " "),
                  let availableNumbers = numberSets.last?.split(separator: " ")
            else { return nil }
            
            let winning = Set(winningNumbers.compactMap { Int($0) })
            let available = Set(availableNumbers.compactMap { Int($0) })
            return ScratchCard(id: id, winning: winning, available: available)
        }
    }
    
    func part1() -> Any {
        scratchCards.map { $0.points }.reduce(0, +)
    }
    
    func part2() -> Any {
        var cardCounts = Array(repeating: 1, count: scratchCards.count)
        
        for (index, card) in scratchCards.enumerated() {
            guard card.numMatches > 0 else { continue }
            for j in 1...card.numMatches {
                cardCounts[index + j] += cardCounts[index]
            }
        }
        return cardCounts.reduce(0, +)
    }
}

struct ScratchCard {
    let id: Int
    let winning: Set<Int>
    let available: Set<Int>
    let numMatches: Int
    let points: Int
    
    init(id: Int, winning: Set<Int>, available: Set<Int>) {
        self.id = id
        self.winning = winning
        self.available = available
        self.numMatches = winning.intersection(available).count
        self.points = numMatches == 0 ? 0 : (pow(2, numMatches - 1) as NSDecimalNumber).intValue
    }
}
