
struct Day07: AdventDay {
  let data: String
  var lines: [Substring] { data.split(whereSeparator: \.isNewline) }
  
  func part1() -> Any {
    let hands = lines.map { Hand(line: $0) }
    return hands.sorted().enumerated().map { index, card in
      return (index + 1) * card.bid
    }.reduce(0, +)
  }
  
  func part2() -> Any {
    let hands = lines.map { Hand(line: $0, jokers: true) }
    return hands.sorted().enumerated().map { index, card in
      return (index + 1) * card.bid
    }.reduce(0, +)
  }
}

struct Hand {
  let bid: Int
  let cards: [String]
  let rank: HandRank
  let jokers: Bool
  
  init(line: Substring, jokers: Bool = false) {
    self.jokers = jokers
        
    let parts = line.split(separator: " ")
    self.bid = Int(String(parts.last ?? "")) ?? 0
    self.cards = parts.first?.compactMap { String($0) } ?? []
    
    var groups:[String: Int] = [:]
    for char in cards {
      groups[char, default: 0] += 1
    }
         
    if jokers {
      let mostCommon = groups.filter { $0.key != "J" }.sorted(by: { $0.value > $1.value }).first?.key ?? "A"
      let cards = parts.first?.replacingOccurrences(of: "J", with: mostCommon).map { String($0) } ?? []
      
      groups.removeAll()
      for char in cards {
        groups[char, default: 0] += 1
      }
    }

    let groupSizes = groups.values.sorted(by: { $0 > $1 }).sorted()
    rank = switch groupSizes {
    case [5]:
      .fiveOfAKind
    case [1, 4]:
      .fourOfAKind
    case [2, 3]:
      .fullHouse
    case [1, 1, 3]:
      .threeOfAKind
    case [1, 2, 2]:
      .twoPair
    case [1, 1, 1, 2]:
      .onePair
    case [1, 1, 1, 1, 1]:
      .highCard
    default:
      .unknown
    }
  }
}

extension Hand: Comparable {
  static func < (lhs: Hand, rhs: Hand) -> Bool {
    guard lhs.rank == rhs.rank else {
      return lhs.rank < rhs.rank
    }
    
    let cardMap = cardMap(jokers: lhs.jokers)
    
    let leftValues = lhs.cards.compactMap { cardMap[$0] }
    let rightValues = rhs.cards.compactMap { cardMap[$0] }
    
    for (left, right) in zip(leftValues, rightValues) {
      guard left != right else { continue }
      return left < right
    }
    return false
  }
  
  static func cardMap(jokers: Bool) -> [String: Int] {
    [
      "J": jokers ? 1 : 11,
      "2": 2,
      "3": 3,
      "4": 4,
      "5": 5,
      "6": 6,
      "7": 7,
      "8": 8,
      "9": 9,
      "T": 10,
      "Q": 12,
      "K": 13,
      "A": 14]
  }
}

enum HandRank: Int, Comparable {
  static func < (lhs: HandRank, rhs: HandRank) -> Bool {
    lhs.rawValue < rhs.rawValue
  }
  
  case unknown
  case highCard
  case onePair
  case twoPair
  case threeOfAKind
  case fullHouse
  case fourOfAKind
  case fiveOfAKind
}
