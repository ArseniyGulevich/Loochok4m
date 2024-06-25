import Foundation

extension Array {
    func at(_ index: Int) -> Array.Element? {
        guard index >= 0 && index <= count - 1 else { return nil }
        return self[index]
    }
}
