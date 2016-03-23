import UIKit
import JavaScriptCore
import Darwin
import XCPlayground
//XCPlaygroundPage.currentPage.needsIndefiniteExecution = true



class SVGView : UIView {
  let commands: [Command];
	
	var path: UIBezierPath {
		get {
			let path = UIBezierPath()
			for c in self.commands {
				c.op(bezierPath: path)
			}
			return path
		}
	}
  
  init(commands: [Command], frame: CGRect) {
    self.commands = commands
    super.init(frame: frame)
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
	
	
  //Write your code in drawRect
  override func drawRect(rect: CGRect) {
    UIColor.blackColor().setStroke()
		self.path.applyTransform(CGAffineTransformTranslate(CGAffineTransformMakeScale(1, -1), 0, -self.frame.height))
		self.path.stroke()
  }
}

let urlPath = "http://localhost:8080/build/bundle.js"
var url2 = NSURL(string: urlPath)!
var request1 = NSURLRequest(URL: url2)
var response: AutoreleasingUnsafeMutablePointer<NSURLResponse? >= nil
var error: NSErrorPointer = nil
var dataVal: NSData =  try NSURLConnection.sendSynchronousRequest(request1, returningResponse: response)

let jsCode = NSString(data: dataVal, encoding: NSASCIIStringEncoding)



let url = NSURL(string: "http://localhost:8080/build/bundle.js")


//let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
//  let jsCode = NSString(data: dataVal!, encoding: NSUTF8StringEncoding)
//  print(jsCode)

  let jc = JSContext()
  jc.evaluateScript(jsCode! as String)
  
  let value = jc.objectForKeyedSubscript("Paths").objectForKeyedSubscript("getPath")
  
  let result = value.callWithArguments([[10,2,29,4,8,20,0,4], [500, 500]])
  print(result)
  
  
  let rect = CGRectMake(0, 0, 500, 500)
  
  let view = SVGView(commands: Command.pathToCommands(result.toString()), frame: rect)
  view.backgroundColor = UIColor.whiteColor()
	
	
	view.path.CGPath
  view.layer.opacity = 1

	
	
	let layer = CAShapeLayer()
	layer.path = view.path.CGPath
	layer.strokeColor = UIColor.redColor().CGColor
	layer.fillColor = UIColor.clearColor().CGColor
	layer.backgroundColor = UIColor.whiteColor().CGColor

	let view2 = UIView(frame: rect)
	view2.backgroundColor = UIColor.whiteColor()
	view2.layer.addSublayer(layer)
	view2





	let anim = CASpringAnimation(keyPath: "path")
//	anim.duration = 2
anim.duration = 12.0;
anim.mass = 5.15
anim.stiffness = 162.07
anim.damping = 81.33;
anim.initialVelocity = 0.00009

	anim.fromValue = view.path.CGPath
	let result2 = value.callWithArguments([[10,2,15,4,8,0,0,10], [500, 500]])
	let view3 = SVGView(commands: Command.pathToCommands(result2.toString()), frame: rect)

	view3.backgroundColor = UIColor.whiteColor()
layer.addAnimation(anim, forKey: "path")
layer.path = view3.path.CGPath


XCPlaygroundPage.currentPage.liveView = view2






	

	
//}

//task.resume()
