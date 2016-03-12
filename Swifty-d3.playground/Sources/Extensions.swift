import Foundation

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
