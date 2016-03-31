import UIKit
import JavaScriptCore
import Darwin
import XCPlayground


func getPathFromCommands(commands: [Command]) -> UIBezierPath {
	let path = UIBezierPath()
	for c in commands {
		c.op(bezierPath: path)
	}
	return path
}


let urlPath = "http://localhost:8080/build/bundle.js"
var url2 = NSURL(string: urlPath)!
var request1 = NSURLRequest(URL: url2)
var response: AutoreleasingUnsafeMutablePointer<NSURLResponse? >= nil
var error: NSErrorPointer = nil
// works better to do sync call in playground, async was messing up the timeline
var dataVal: NSData =  try NSURLConnection.sendSynchronousRequest(request1, returningResponse: response)


let jsCode = NSString(data: dataVal, encoding: NSASCIIStringEncoding)
let url = NSURL(string: "http://localhost:8080/build/bundle.js")


let jc = JSContext()
jc.evaluateScript(jsCode! as String)

let value = jc.objectForKeyedSubscript("Paths").objectForKeyedSubscript("getPath")

let result = value.callWithArguments([[10,2,29,4,8,20,0,4], [500, 500]])
print(result)


let rect = CGRectMake(0, 0, 500, 500)

let layer = CAShapeLayer()
layer.strokeColor = UIColor.redColor().CGColor
layer.fillColor = UIColor.clearColor().CGColor
layer.backgroundColor = UIColor.whiteColor().CGColor

layer.path = getPathFromCommands(Command.pathToCommands(result.toString())).CGPath


let view = UIView(frame: rect)
view.backgroundColor = UIColor.whiteColor()
view.layer.addSublayer(layer)

let anim = CASpringAnimation(keyPath: "path")
anim.duration = 5.0;
anim.mass = 5.15
anim.stiffness = 162.07
anim.damping = 1.33;
anim.initialVelocity = 0.00009


anim.fromValue = layer.path
let result2 = value.callWithArguments([[10,2,15,4,8,0,0,10], [500, 500]])

layer.addAnimation(anim, forKey: "path")
layer.path = getPathFromCommands(Command.pathToCommands(result2.toString())).CGPath


XCPlaygroundPage.currentPage.liveView = view



