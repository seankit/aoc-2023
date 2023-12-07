import ArgumentParser

// Add each new day implementation to this array:
let allChallenges: [any AdventDay] = [
  Day00(),
  Day01(),
  Day02(),
  Day03(),
  Day04(),
  Day05(),
  Day06(),
]

@main
struct AdventOfCode: AsyncParsableCommand {
  @Argument(help: "The day of the challenge. For December 1st, use '1'.")
  var day: Int?

  @Flag(help: "Benchmark the time taken by the solution")
  var benchmark: Bool = false
  
  @Option(help: "The day of the challenge to fetch input and generate source and test files.")
  var setupDay: Int?

  /// The selected day, or the latest day if no selection is provided.
  var selectedChallenge: any AdventDay {
    get throws {
      if let day {
        if let challenge = allChallenges.first(where: { $0.day == day }) {
          return challenge
        } else {
          throw ValidationError("No solution found for day \(day)")
        }
      } else {
        return latestChallenge
      }
    }
  }

  /// The latest challenge in `allChallenges`.
  var latestChallenge: any AdventDay {
    allChallenges.max(by: { $0.day < $1.day })!
  }

  func run(part: () async throws -> Any, named: String) async -> Duration {
    var result: Result<Any, Error> = .success("<unsolved>")
    let timing = await ContinuousClock().measure {
      do {
        result = .success(try await part())
      } catch {
        result = .failure(error)
      }
    }
    switch result {
    case .success(let success):
      print("\(named): \(success)")
    case .failure(let failure):
      print("\(named): Failed with error: \(failure)")
    }
    return timing
  }

  func run() async throws {
    if let setupDay {
      let setupService = AdventDaySetupService(day: setupDay, sessionToken: "53616c7465645f5fb7583662b957c7c01bb0b15d7870992ad81993e6c0f197ee476a10582998ece103a6f6d6be073f5781aee20e91c5c7a1ca952653f1469ae3")
      try await setupService.generateFiles()
    } else {
      let challenge = try selectedChallenge
      print("Executing Advent of Code challenge \(challenge.day)...")
      
      let timing1 = await run(part: challenge.part1, named: "Part 1")
      let timing2 = await run(part: challenge.part2, named: "Part 2")
      
      if benchmark {
        print("Part 1 took \(timing1), part 2 took \(timing2).")
        #if DEBUG
        print("Looks like you're benchmarking debug code. Try swift run -c release")
        #endif
      }
    }
  }
}
