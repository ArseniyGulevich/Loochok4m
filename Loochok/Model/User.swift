import Foundation

/*
 "id": 2,
 "email": "user_0@email.com",
 "jti": "06aedcf9-5088-4d56-b3c4-a14a25e7b9e9",
 "admin": false,
 "created_at": "2024-06-11T11:34:44.141+03:00",
 "updated_at": "2024-06-11T11:34:44.141+03:00"
*/

class User: Equatable, Hashable, Codable {
    var id: Int
    var name: String?
    var nick: String?
    var email: String?
    var isAdmin: Bool = false
    
    // Extra
    var psw: String?
    var info: String?
    
    // Equatable
    public static func ==(lhs: User, rhs: User) -> Bool { return lhs.id == rhs.id }
    // Hashable
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    
    // MARK: - Initializers
    init?(json: JSON?) {
        guard let json = json,
              let id = json["id"] as? Int
        else { return nil }
        
        self.id = id
        self.name = json.string("name")
        self.nick = json.string("nick")
        self.email = json.string("email")
        self.isAdmin = json.bool("isAdmin") ?? false
        // Extra
        self.psw = json.string("password")
    }
}

// MARK: - Extra
extension User {
    static var isAuth: Bool { return (appService.user != nil) && (appService.token_isExist) }
    var isMe: Bool { true }
    var tagList: [Tag] { Tag.userList }
}

// MARK: - Helpers
extension User {
}

// MARK: - signOut
extension User {
    static func signOut() {
        appService.token_save(nil, nil)
        appService.user = nil
        
        LDService.removeAll()
        KingfisherHelper.clearCache()
    }
    static func signOut_lite() {
        appService.token_save(nil, nil)
        appService.user = nil
    }
}
