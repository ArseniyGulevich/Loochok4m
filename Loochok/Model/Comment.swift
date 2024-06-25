import Foundation

/*
 "id": 1,
 "body": "Группу свои ценным жизнь тут или элементом одежды идеи жизнь способом.",
 "post_id": 1,
 "user": {
     "id": 2,
     "email": "user_0@email.com",
     "jti": "06aedcf9-5088-4d56-b3c4-a14a25e7b9e9",
     "admin": false,
     "created_at": "2024-06-11T11:34:44.141+03:00",
     "updated_at": "2024-06-11T11:34:44.141+03:00"
 },
 "created_at": "2024-06-11T11:34:50.302+03:00",
 "url": "http://178.250.152.108:3000/api/v1/comments/1.json"
 */

class Comment: Equatable, Hashable {
    var id: Int
    var date: Date
    var postId: Int
    var text: String
    var user: User
    var path: String
    
    //Extra
    var isLike: Bool = false
    
    // Equatable
    public static func ==(lhs: Comment, rhs: Comment) -> Bool { return lhs.id == rhs.id }
    // Hashable
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    
    // MARK: - Initializers
    init?(json: JSON?) {
        guard let json = json,
              let id = json.integer("id"),
              let date = json.string("created_at")?.toDate(.api1),
              let postId = json.integer("post_id"),
              let text = json.string("body"),
              let user = User.init(json: json.json("user")),
              let path = json.string("url")
        else { return nil }
        
        self.id = id
        self.date = date
        self.postId = postId
        self.text = text
        self.user = user
        self.path = path
    }
    // loadList
    static func loadList(_ jsonList: [JSON]?) -> [Comment] {
        guard let jsonList else { return [] }
        let list = jsonList.compactMap { Comment.init(json: $0) }
        return list
    }
}
