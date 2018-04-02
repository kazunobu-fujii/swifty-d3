import Foundation
import UIKit


public struct Command {
  let code: String;
  let args: [Double];
  
  public static func pathToCommands(path: String) -> [Command]{
	let tokens = "([a-m])|(([0-9\\.]+,?)+)".regExp().matches(input: path)
	return tokens.chunk(chunkSize: 2).map { Command(code: $0[0], args: $0[1]) }
  }
  
  public init(code: String, args: String) {
    self.code = code
	self.args = args.splitBy(token: ",").map{ Double.init($0)! }
  }
  
  public var op: (_ bezierPath: UIBezierPath) -> Void {
    get {
      let args = self.args
      switch self.code {
      case "M":
		return { $0.move(to: CGPoint(x: args[0], y: args[1])) }
      case "L":
		return { $0.addLine(to: CGPoint(x: args[0], y: args[1])) }
      case "C":
		return { $0.addCurve(to: CGPoint(x: args[4], y: args[5]),
          controlPoint1: CGPoint(x: args[0], y: args[1]),
          controlPoint2: CGPoint(x: args[2], y: args[3])) }
      default:
        return {_ in }
      }
    }
  }
}
