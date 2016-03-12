////: Playground - noun: a place where people can play
//
import UIKit
import JavaScriptCore
import XCPlayground
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true



struct RegExp {
  let regExp: NSRegularExpression
  let pattern: String

  init(_ pattern: String) {
    self.pattern = pattern
    do {
      try self.regExp = NSRegularExpression(pattern: pattern, options: .CaseInsensitive)
    } catch _ {
      self.regExp = NSRegularExpression()
    }
  }

  func matches(input: String) -> [String] {
    let range = NSMakeRange(0, input.characters.count)
    return self.regExp.matchesInString(input, options: .WithoutAnchoringBounds, range: range)
        .map { (input as NSString).substringWithRange($0.range) }
  }

  func test(input: String) -> Bool {
    let range = NSMakeRange(0, input.characters.count)
    return self.regExp.numberOfMatchesInString(input, options: .WithoutAnchoringBounds, range: range) > 0
  }

  func test(input: Character) -> Bool {
    return self.test(String(input))
  }
}



struct Command {
  let code: String;
  let args: [Double];

  init(code: String, args: String) {
    self.code = code
    self.args = args.splitBy(",").map{ Double.init($0)! }
  }

  var op: (bezierPath: UIBezierPath) -> Void {
    get {
      let args = self.args
      switch self.code {
      case "M":
        return { $0.moveToPoint(CGPoint(x: args[0], y: args[1])) }
      case "L":
        return { $0.addLineToPoint(CGPoint(x: args[0], y: args[1])) }
      case "C":
        return { $0.addCurveToPoint(CGPoint(x: args[4], y: args[5]),
                      controlPoint1: CGPoint(x: args[0], y: args[1]),
                      controlPoint2: CGPoint(x: args[2], y: args[3])) }
      default:
        return {_ in }
      }
    }
  }
}



extension String {
  func regExp() -> RegExp {
    return RegExp(self)
  }

  func splitBy(token: String) -> [String] {
    return self.characters.split { String($0) == token }.map { String.init($0) }
  }
}



extension Array {
  func chunk(chunkSize : Int) -> Array<Array<Element>> {
    return 0.stride(to: self.count, by: chunkSize)
      .map { Array(self[$0..<$0.advancedBy(chunkSize, limit: self.count)]) }
  }
}


func pathToCommands(path: String) -> [Command]{
  let tokens = "([a-m])|(([0-9\\.]+,?)+)".regExp().matches(path)
  return tokens.chunk(2)
    .map { Command(code: $0[0], args: $0[1]) }
}


class SVGView : UIView {
  let commands: [Command];
  init(commands: [Command], frame: CGRect) {
    self.commands = commands
    super.init(frame: frame)
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }

  //Write your code in drawRect
  override func drawRect(rect: CGRect) {
    let myBezier = UIBezierPath()
    for c in self.commands {
      c.op(bezierPath: myBezier)
    }
    UIColor.blackColor().setStroke()
    myBezier.stroke()
  }
}



let url = NSURL(string: "http://localhost:8080/build/bundle.js")


let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
  let jsCode = NSString(data: data!, encoding: NSUTF8StringEncoding)
  print(jsCode)
  
  let jc = JSContext()
  jc.evaluateScript(jsCode! as String)
  
  let value = jc.objectForKeyedSubscript("Paths").objectForKeyedSubscript("getPath")
  let result = value.callWithArguments([])
  print(result)
  
  
  let rect = CGRectMake(0, 0, 500, 500)
  
  let view = SVGView(commands: pathToCommands(result.toString()), frame: rect)
  
  
  view.backgroundColor = UIColor.whiteColor()
}

task.resume()
