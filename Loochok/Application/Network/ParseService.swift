import Foundation

class parseDict<T: Decodable> {
    // let object = parseDict<Article>().getObject(objectDict)
    func getObject(_ objectDict: JSON?) -> T? {
        guard let objectDict = objectDict else { return nil }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: objectDict, options: [])
            let object = try JSONDecoder().decode(T.self, from: jsonData)
            //print("parseDict \(type(of: T.self)): \(object)")
            return object
        } catch {
            print("Error: Couldn't decode data into \(type(of: T.self))")
            print(error.localizedDescription)
        }
        return nil
    }
    // let objectList = parseDict<Article>().getList(objectDict)
    func getList(_ objectDict: [JSON]) -> [T] {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: objectDict, options: [])
            let objectList = try JSONDecoder().decode([T].self, from: jsonData)
            //print("parseDict \(type(of: T.self)): \(objectList)")
            return objectList
        } catch {
            print("Error: Couldn't decode data into \(type(of: T.self))")
            print(error.localizedDescription)
        }
        return []
    }
}
