//
//  File.swift
//  
//
//  Created by Sean Kelly on 12/2/23.
//

import Foundation

// MARK: Day02 Advent Day

struct Day02: AdventDay {
    var data: String
    
    var lines: [Substring] { data.split(whereSeparator: \.isNewline) }
    
    var games: [Game] {
        lines.compactMap { line in
            let split = line.split(separator: ":")
            guard let idString = split.first?.split(separator: " ").last,
                  let id = Int("\(idString)"),
                  let roundStrings = split.last?.split(separator: ";") else { return nil }
            
            let rounds = roundStrings.map { Round(roundString: $0) }
            return Game(id: id, rounds: rounds)
        }
    }
    
    func part1() -> Any {
        return games.filter(\.isValid).map { $0.id }.reduce(0, +)
    }
    
    func part2() -> Any {
        return games.map { $0.power }.reduce(0, +)
    }
}

// MARK: Protocols

enum ValidatingMax: Int {
    case red = 12
    case green = 13
    case blue = 14
}

protocol Validating {
    var isValid: Bool { get }
}

protocol ComputesPower {
    var power: Int { get }
}

// MARK: Models

// MARK: Game

struct Game {
    let id: Int
    let rounds: [Round]
    
    init(id: Int, rounds: [Round]) {
        self.id = id
        self.rounds = rounds
    }
}

extension Game: Validating {
    var isValid: Bool {
        rounds.allSatisfy(\.isValid)
    }
}

extension Game: ComputesPower {
    var power: Int {
        let red = rounds.max(by: { $0.red ?? 0 < $1.red ?? 0 })?.red ?? 1
        let blue = rounds.max(by: { $0.blue ?? 0 < $1.blue ?? 0 })?.blue ?? 1
        let green = rounds.max(by: { $0.green ?? 0 < $1.green ?? 0 })?.green ?? 1
        return red * blue * green
    }
}

// MARK: Round

struct Round {
    let red: Int?
    let blue: Int?
    let green: Int?
    
    init(roundString: Substring) {
        var map: [Substring: Int] = [:]
        let components = roundString.split(separator: ",")
        for component in components {
            let parts = component.split(separator: " ")
            map[parts[1]] = Int("\(parts[0])")
        }
        self.init(red: map["red"], blue: map["blue"], green: map["green"])
    }

    init(red: Int?, blue: Int?, green: Int?) {
        self.red = red
        self.blue = blue
        self.green = green
    }
}

extension Round: Validating {
    var isValid: Bool {
        red ?? 0 <= ValidatingMax.red.rawValue
            && blue ?? 0 <= ValidatingMax.blue.rawValue
            && green ?? 0 <= ValidatingMax.green.rawValue
    }
}
