import Foundation

public struct RegExp {
  let regExp: NSRegularExpression
  let pattern: String
  
  public init(_ pattern: String) {
    self.pattern = pattern
    do {
      try self.regExp = NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    } catch _ {
      self.regExp = NSRegularExpression()
    }
  }
  
  public func matches(input: String) -> [String] {
    let range = NSMakeRange(0, input.count)
	return self.regExp.matches(in: input, options: .withoutAnchoringBounds, range: range)
		.map { (input as NSString).substring(with: $0.range) }
  }
  
  public func test(input: String) -> Bool {
    let range = NSMakeRange(0, input.count)
	return self.regExp.numberOfMatches(in: input, options: .withoutAnchoringBounds, range: range) > 0
  }
  
  public func test(input: Character) -> Bool {
	return self.test(input: String(input))
  }
}
