import Foundation

// MARK: - Data
extension Data {
    var string: String? {
        return (try? JSONSerialization.jsonObject(with: self, options: [])) as? String
    }
    var stringList: [String]? {
        return (try? JSONSerialization.jsonObject(with: self, options: [])) as? [String]
    }
    var json: JSON? {
        return try? JSONSerialization.jsonObject(with: self, options: []) as? JSON
    }
    var jsonList: [JSON]? {
        return try? JSONSerialization.jsonObject(with: self, options: []) as? [JSON]
    }
}
