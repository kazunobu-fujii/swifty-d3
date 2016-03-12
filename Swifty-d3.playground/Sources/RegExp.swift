import Foundation

public struct RegExp {
  let regExp: NSRegularExpression
  let pattern: String
  
  public init(_ pattern: String) {
    self.pattern = pattern
    do {
      try self.regExp = NSRegularExpression(pattern: pattern, options: .CaseInsensitive)
    } catch _ {
      self.regExp = NSRegularExpression()
    }
  }
  
  public func matches(input: String) -> [String] {
    let range = NSMakeRange(0, input.characters.count)
    return self.regExp.matchesInString(input, options: .WithoutAnchoringBounds, range: range)
      .map { (input as NSString).substringWithRange($0.range) }
  }
  
  public func test(input: String) -> Bool {
    let range = NSMakeRange(0, input.characters.count)
    return self.regExp.numberOfMatchesInString(input, options: .WithoutAnchoringBounds, range: range) > 0
  }
  
  public func test(input: Character) -> Bool {
    return self.test(String(input))
  }
}
