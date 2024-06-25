import Foundation

/*
 "id": 1,
 "title": "Как расписать кеды",
 "type": "TutorialPost",
 "description": "Если вы начинающий кастомер, обычны",
 "user": {
     "id": 2,
     "email": "user_0@email.com",
     "jti": "06aedcf9-5088-4d56-b3c4-a14a25e7b9e9",
     "admin": false,
     "created_at": "2024-06-11T11:34:44.141+03:00",
     "updated_at": "2024-06-11T11:34:44.141+03:00"
 },
 "created_at": "2024-06-11T11:34:45.134+03:00",
 "post_image": "http://178.250.152.108:3000/uploads/tutorial_post/post_image/1/0eeaccc34c.jpg",
 "url": "http://178.250.152.108:3000/api/v1/posts/kak-raspisat-kedy.json"
 */

class Post: Equatable, Hashable {
    var id: Int
    var type: TypePost
    var date: Date
    var title: String
    var description: String
    var user: User
    var pathPhoto: String
    var link: String?
    
    //Extra
    var isLike: Bool = false
    
    // Equatable
    public static func ==(lhs: Post, rhs: Post) -> Bool { return lhs.id == rhs.id }
    // Hashable
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    
    // MARK: - Initializers
    init?(json: JSON?) {
        guard let json = json,
              let id = json.integer("id"),
              let type = TypePost.getById(json.string("type")),
              let date = json.string("created_at")?.toDate(.api1),
              let user = User.init(json: json.json("user")),
              let pathPhoto = json.string("post_image")
        else { return nil }
        
        self.id = id
        self.type = type
        self.date = date
        self.title = json.string("title") ?? ""
        self.description = json.string("description") ?? ""
        self.user = user
        self.pathPhoto = pathPhoto
        self.link = json.string("url")
    }
    // loadList
    static func loadList(_ jsonList: [JSON]?) -> [Post] {
        guard let jsonList = jsonList else { return [] }
        let list = jsonList.compactMap { Post.init(json: $0) }
        return list
    }
}

// MARK: - Extra
extension Post {
    var filterText: String { "\(title.lowercased()) | \(description.lowercased())" }
}
