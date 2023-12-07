import Foundation

struct AdventDaySetupService {
  private let day: Int
  private let sessionToken: String
  
  init(day: Int, sessionToken: String) {
    self.day = day
    self.sessionToken = sessionToken
  }
  
  private var dayString: String {
    "Day\(String(format: "%02d", day))"
  }
  
  private var cookie: HTTPCookie {
    let cookieProperties: [HTTPCookiePropertyKey: Any] = [
      .domain: "adventofcode.com",
      .path: "/",
      .name: "session",
      .value: sessionToken
    ]
    
    return HTTPCookie(properties: cookieProperties)!
  }
  
  func generateFiles() async throws {
    createSourceFile()
    try await createTestFile()
    try await createInputFile()
  }
  
  func createSourceFile() {
    let sourceFilePath = FileManager.default.currentDirectoryPath + "/Sources/\(dayString).swift"
    
    guard !validFileAlreadyExists(atPath: sourceFilePath) else {
      print("\(dayString) source file already exists.")
      return
    }
    
    let fileContent = Data(
        """
        
        struct \(dayString): AdventDay {
          let data: String
          var lines: [Substring] { data.split(whereSeparator: \\.isNewline) }
            
          func part1() -> Any {
            return 0
          }
        
          func part2() -> Any {
            return 0
          }
        }
        """.utf8)
    
    FileManager.default.createFile(atPath: sourceFilePath, contents: fileContent)
    print("\(dayString) source file created.")
  }
  
  func createInputFile() async throws {
    let inputFilePath = FileManager.default.currentDirectoryPath + "/Sources/Data/\(dayString).txt"
    
    guard !validFileAlreadyExists(atPath: inputFilePath) else {
      print("\(dayString) input file already exists.")
      return
    }
    
    let url = URL(string: "http://www.adventofcode.com/2023/day/\(day)/input")!
    let puzzleInputRequest = try makeRequest(with: url)
    
    let fileContent = try await fetchData(for: puzzleInputRequest)
    FileManager.default.createFile(atPath: inputFilePath, contents: fileContent)
    print("\(dayString) input file created.")
  }
  
  func createTestFile() async throws {
    let testFilePath = FileManager.default.currentDirectoryPath + "/Tests/\(dayString).swift"
    
    guard !validFileAlreadyExists(atPath: testFilePath) else {
      print("\(dayString) test file already exists.")
      return
    }
    
    let url = URL(string: "http://www.adventofcode.com/2023/day/\(day)")!
    let puzzleDescriptionPageRequest = try makeRequest(with: url)

    let data = try await fetchData(for: puzzleDescriptionPageRequest)
    let puzzleExample = PuzzleDescriptionParser.parseExample(html: data)
    let fileContent = generateTestFileContent(from: puzzleExample)
    
    FileManager.default.createFile(atPath: testFilePath, contents: fileContent)
    print("\(dayString) test file created.")
  }
  
  func generateTestFileContent(from example: PuzzleExample?) -> Data {
    let part1Answer = example?.answers?.first ?? "0"
    let part2Answer = example?.answers?.last ?? "0"

    return Data(
      """
      import Foundation
      import XCTest
      @testable import AdventOfCode
      
      final class \(dayString)Tests: XCTestCase {
      
        let testData = \"\"\"
          \(example?.sampleInput ?? "")\"\"\"
      
        func testPart1() {
          let challenge = \(dayString)(data: testData)
          XCTAssertEqual(String(describing: challenge.part1()), \"\(part1Answer)\")
        }
      
        func testPart2() {
          let challenge = \(dayString)(data: testData)
          XCTAssertEqual(String(describing: challenge.part2()), \"\(part2Answer)\")
        }
      }
      """.utf8)
  }
  
  private func validFileAlreadyExists(atPath path: String) -> Bool {
    guard FileManager.default.fileExists(atPath: path),
          let fileURL = URL(string: "file://\(path)"),
          let content = try? String(contentsOf: fileURL, encoding: .utf8)
    else { return false }
    
    return !content.isEmpty
  }
}

extension AdventDaySetupService {
  private func makeRequest(with url: URL) throws -> URLRequest {
    var request = URLRequest(url: url)
    request.allHTTPHeaderFields = HTTPCookie.requestHeaderFields(with: [cookie])
    return request
  }
  
  private func fetchData(for request: URLRequest) async throws -> Data {
    let (data, response) = try await URLSession.shared.data(for: request)
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
      throw URLError(.badServerResponse)
    }
    return data
  }
}

struct PuzzleExample {
  let sampleInput: String?
  let answers: [String]?
}

struct PuzzleDescriptionParser {
  static func parseExample(html: Data) -> PuzzleExample? {
    guard let html = String(data: html, encoding: .utf8) else { return nil }
    
    let prePattern = "<pre>(.*?)</pre>"
    let sampleInputPattern = "<code>([^<]*)</code>"
    let answerPattern = "<code><em>([^<]*)</em></code>"
    let articlePattern = "<article class=\"day-desc\">(.*?)</article>"
    
    let sampleInput = matches(for: prePattern, in: html).compactMap { pre in
      matches(for: sampleInputPattern, in: pre).first.map { $0.replacingOccurrences(of: "\n", with: "\n    ") }
    }.first
    
    let answers = matches(for: articlePattern, in: html).compactMap { article in
      matches(for: answerPattern, in: article).last
    }
    
    return PuzzleExample(sampleInput: sampleInput, answers: answers)
  }
  
  private static func matches(for pattern: String, in text: String) -> [String] {
    do {
      let regex = try NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators])
      let results = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
      return results.map {
        String(text[Range($0.range(at: 1), in: text)!])
      }
    } catch {
      print("Invalid regex: \(error.localizedDescription)")
      return []
    }
  }
}
