import UIKit
import JavaScriptCore
import Darwin
import XCPlayground
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true


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
    myBezier.applyTransform(CGAffineTransformTranslate(CGAffineTransformMakeScale(1, -1), 0, -self.frame.height))
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
  
  let result = value.callWithArguments([[10,2,29,4,8,20,0,4], [500, 500]])
  print(result)
  
  
  let rect = CGRectMake(0, 0, 500, 500)
  
  let view = SVGView(commands: Command.pathToCommands(result.toString()), frame: rect)
  view.backgroundColor = UIColor.whiteColor()
  view.layer.opacity = 1

  
}

task.resume()
