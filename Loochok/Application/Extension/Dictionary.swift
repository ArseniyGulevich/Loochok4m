import Foundation

// MARK: - Typealias
typealias JSON = [String: Any]

//словарь в строку запроса
extension Dictionary {
    var queryString: String {
        var output: String = ""
        self.forEach { (key, value) in
            if let list = value as? Array<AnyObject> {
                list.forEach { output += "\(key)=\($0)&" }
            } else { output += "\(key)=\(value)&" }
        }
        output = String(output.dropLast())
        output = !output.isEmpty ? "?\(output)" : ""
        return output
    }
}

// MARK: - JSON - ParseHelper
// MARK: - HelpersFunctions
func printJSONString(_ json: Any?, _ title: String = "") {
    guard let json = json else { print("\(title) - json is nil"); return }
    //print(type(of: json))
    if let dict = json as? JSON { print("🤌=\(title)=🤌\n", dict.jsonString ?? "invalid json") }
    else if let dict = json as? [JSON] { print("🤌=\(title)=🤌\n", dict.toJSONString()) }
    else if let jsonStr = json as? String {
        print("\(title)\n", JSON.fromString(jsonStr)?.jsonString ?? "invalid json")
    } else { print("\(title) - json is unknown") }
}
//
// MARK: Array Dict -> JSON String
extension Collection where Iterator.Element == JSON {
    func toJSONString(options: JSONSerialization.WritingOptions = .prettyPrinted) -> String {
        guard let arr = self as? [JSON],
              let dat = try? JSONSerialization.data(withJSONObject: arr, options: options),
              let str = String(data: dat, encoding: String.Encoding.utf8)
        else { return "[nil]" }
        return str
    }
}
// MARK: Dict -> JSON String
extension Dictionary {
    var jsonData: Data? {
        return try? JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
    }
    var jsonString: String? {
        guard let jsonData = jsonData else { return  nil }
        let jsonString = String(data: jsonData, encoding: .utf8)
        return jsonString
    }
}

extension JSON {
    static func fromString(_ string: String) -> JSON? {
        guard let data = string.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data, options: []) as? JSON
        else { return nil }
        return json
    }
    static func jsonListToString(_ json: [JSON]) -> String? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: json, options: []),
              let res = String(data: jsonData, encoding: .utf8)
        else { return nil }
        return res
    }
}

// MARK: Format
extension JSON {
    func string(_ key: String) -> String? {
        if let value = self[key] as? String { return value }
        else { return nil }
    }
    func stringList(_ key: String) -> [String]? {
        if let value = self[key] as? [String] { return value }
        else { return nil }
    }
    func double(_ key: String) -> Double? {
        if let value = self[key] as? Double { return value }
        else if let value = self[key] as? String { return value.doubleValue }
        else { return nil }
    }
    func integer(_ key: String) -> Int? {
        if let value = self[key] as? Int { return value }
        else if let value = (self[key] as? String)?.intValue { return value }
        else { return nil }
    }
    func integerList(_ key: String) -> [Int]? {
        if let value = self[key] as? [Int] { return value }
        else { return nil }
    }
    func bool(_ key: String) -> Bool? {
        if let value = self[key] as? Bool { return value }
        else if let value = self[key] as? String { return (value == "true") }
        else if let value = self[key] as? Int { return (value == 1) }
        else { return nil }
    }
    func json(_ key: String) -> JSON? {
        if let value = self[key] as? JSON { return value }
        else { return nil }
    }
    func jsonList(_ key: String) -> [JSON]? {
        if let value = self[key] as? [JSON] { return value }
        else { return nil }
    }
}

// MARK: - Codable
extension Encodable {
    var json: JSON? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? JSON }
    }
}

// MARK: - JSON to dataDict
import Alamofire
extension Dictionary {
    var dataDict: [String: Data] {
        var dd: [String: Data] = [:]
        self.forEach { (key, value) in
            print("👉 \(key)")
            if let valP = value as? String { dd["\(key)"] = Data("\(valP)".utf8) }
            else if let valP = value as? Int { dd["\(key)"] = Data("\(valP)".utf8) }
            else if let valP = value as? Double { dd["\(key)"] = Data("\(valP)".utf8) }
            //else if let valP = value as? Decimal { dd["\(key)"] = Data("\(valP.doubleV)".utf8) }
            else if let valP = value as? Bool { dd["\(key)"] = Data("\(valP)".utf8) }
            else if let valP = value as? JSON,
                    let jsonString = valP.jsonString {
                dd["\(key)"] = Data("\(jsonString)".utf8)
            } else if let valP = value as? [JSON],
                      let dictListStr = JSON.jsonListToString(valP) {
                //printJSONString(valP, "🤌 [JSON]: \(key)")
                //print("🤌 [JSON]: \(dictListStr)")
                dd["\(key)"] = Data("\(dictListStr)".utf8)
            } else { print("👿 \(key) bad format for \(value)") }
        }
        
        return dd
    }
}
