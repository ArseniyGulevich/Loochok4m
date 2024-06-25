import Foundation

class Tag: Equatable, Hashable {
    var id: String
    var name: String
    
    // Equatable
    public static func ==(lhs: Tag, rhs: Tag) -> Bool { return lhs.id == rhs.id }
    // Hashable
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    
    // MARK: - Initializers
    init(_ id: String, _ name: String) {
        self.id = id
        self.name = name
    }
    init?(json: JSON?) {
        guard let json = json,
              let id = json.string("id"),
              let name = json.string("name")
        else { return nil }
        
        self.id = id
        self.name = name
    }
    // loadList
    static func loadList(_ jsonList: [JSON]?) -> [Tag] {
        guard let jsonList = jsonList else { return [] }
        let list = jsonList.compactMap { Tag.init(json: $0) }
        return list
    }
}

// MARK: - Extra
extension Tag {
}

// MARK: - ProtocolTag
extension Tag: ProtocolTag {
    var tagId: String { id }
    var tagName: String { name }
}

// MARK: - Demo
extension Tag {
    static let tagList: [Tag] = {
        [Tag("1", "обувь".uppercased()),
         Tag("2", "роспись".uppercased())]
    }()
    static let thingList: [Tag] = {
        [Tag("0", "Все".uppercased()),
         Tag("1", "Одежда".uppercased()),
         Tag("2", "Обувь".uppercased()),
         Tag("3", "Другое".uppercased())]
    }()
    static let userList: [Tag] = {
        [Tag("1", "Одежда".uppercased()),
         Tag("2", "Обувь".uppercased()),
         Tag("3", "Роспись".uppercased()),
         Tag("4", "Аксессуары".uppercased()),
         Tag("5", "Другое".uppercased())]
    }()
}
