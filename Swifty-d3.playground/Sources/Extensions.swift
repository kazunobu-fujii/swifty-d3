import Foundation

extension String {
  func regExp() -> RegExp {
    return RegExp(self)
  }
  
  func splitBy(token: String) -> [String] {
    return self.split { String($0) == token }.map { String.init($0) }
  }
}


extension Array {
  func chunk(chunkSize : Int) -> Array<Array<Element>> {
	return stride(from:0, to: self.count, by: chunkSize)
		.map { Array(self[$0..<$0.advanced(by: chunkSize)]) }
  }
}
