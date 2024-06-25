import Foundation

class Banner: Equatable, Hashable {
    var id: String
    var name: String
    var pathPhoto: String
    
    // Equatable
    public static func ==(lhs: Banner, rhs: Banner) -> Bool { return lhs.id == rhs.id }
    // Hashable
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    
    // MARK: - Initializers
    init(_ id: String, _ name: String, _ pathPhoto: String) {
        self.id = id
        self.name = name
        self.pathPhoto = pathPhoto
    }
    init?(json: JSON?) {
        guard let json = json,
              let id = json.string("id"),
              let name = json.string("name"),
              let pathPhoto = json.string("pathPhoto")
        else { return nil }
        
        self.id = id
        self.name = name
        self.pathPhoto = pathPhoto
    }
    // loadList
    static func loadList(_ jsonList: [JSON]?) -> [Banner] {
        guard let jsonList else { return [] }
        let list = jsonList.compactMap { Banner.init(json: $0) }
        return list
    }
}

// MARK: - Extra
extension Banner {
    var filterText: String { "\(name.lowercased())" }
}

// MARK: - Demo
extension Banner {
    static let demoList: [Banner] = {
        var list: [Banner] = []
        list.append(Banner("1", "Эко", "banner1"))
        list.append(Banner("2", "Шитье", "banner2"))
        list.append(Banner("3", "Профи", "banner3"))
        list.append(Banner("4", "Легкие", "banner4"))
        return list
    }()
}
