import UIKit
import JavaScriptCore
import Darwin
import PlaygroundSupport


// Load the JS
let url = NSURL(string: "http://localhost:8080/build/bundle.js")!
var request = NSURLRequest(url: url as URL)
var response: AutoreleasingUnsafeMutablePointer<URLResponse?>? = nil
var error: NSErrorPointer = nil
// works better to do sync call in playground, async was messing up the timeline
var dataVal: NSData =  try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: response) as NSData
let jsCode = NSString(data: dataVal as Data, encoding: String.Encoding.ascii.rawValue)

let jc = JSContext()!
jc.evaluateScript(jsCode! as String)

let getPathFunc = jc.objectForKeyedSubscript("Paths").objectForKeyedSubscript("getPath")

let result = getPathFunc!.call(withArguments: [[10,2,29,4,8,20,0,4], [500, 500]])


func getPathFromCommands(commands: [Command]) -> UIBezierPath {
  let path = UIBezierPath()
  for c in commands {
    c.op(path)
  }
  return path
}

let rect = CGRect(x: 0, y: 0, width: 500, height: 500)
let layer = CAShapeLayer()
layer.strokeColor = UIColor.red.cgColor
layer.fillColor = UIColor.clear.cgColor
layer.backgroundColor = UIColor.white.cgColor

layer.path = getPathFromCommands(commands: Command.pathToCommands(path: result!.toString())).cgPath



let view = UIView(frame: rect)
view.backgroundColor = UIColor.white
view.layer.addSublayer(layer)

let anim = CASpringAnimation(keyPath: "path")
anim.duration = 5.0;
anim.mass = 5.15
anim.stiffness = 162.07
anim.damping = 81.33;
anim.initialVelocity = 0.00009
anim.fromValue = layer.path

let result2 = getPathFunc!.call(withArguments: [[10,2,15,4,8,0,0,10], [500, 500]])

layer.add(anim, forKey: "path")
layer.path = getPathFromCommands(commands: Command.pathToCommands(path: result2!.toString())).cgPath

PlaygroundSupport.PlaygroundPage.current.liveView = view


