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
        let roundStrings = split.last?.split(separator: ";")
      else { return nil }

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
}

extension Game: Validating {
  var isValid: Bool {
    rounds.allSatisfy(\.isValid)
  }
}

extension Game: ComputesPower {
  var power: Int {
    var red: Int = 0
    var blue: Int = 0
    var green: Int = 0

    for round in rounds {
      for block in round.revealedCubes {
        switch block {
        case .red(let amount):
          red = max(red, amount)
        case .blue(let amount):
          blue = max(blue, amount)
        case .green(let amount):
          green = max(green, amount)
        case .unknown:
          continue
        }
      }
    }
    return red * blue * green
  }
}

// MARK: ColorBlock

enum ColorBlock {
  case red(Int)
  case blue(Int)
  case green(Int)
  case unknown

  static func fromString(_ component: Substring) -> ColorBlock {
    let parts = component.split(separator: " ")
    guard let value = Int("\(parts[0])") else { return .unknown }

    return switch parts.last {
    case "red":
      .red(value)
    case "blue":
      .blue(value)
    case "green":
      .green(value)
    default:
      .unknown
    }
  }
}

// MARK: Round

struct Round {
  let revealedCubes: [ColorBlock]

  init(roundString: Substring) {
    revealedCubes = roundString.split(separator: ",").map { ColorBlock.fromString($0) }
  }
}

extension Round: Validating {
  var isValid: Bool {
    revealedCubes.allSatisfy { block in
      return switch block {
      case .red(let amount):
        amount <= ValidatingMax.red.rawValue
      case .blue(let amount):
        amount <= ValidatingMax.blue.rawValue
      case .green(let amount):
        amount <= ValidatingMax.green.rawValue
      case .unknown:
        false
      }
    }
  }
}
