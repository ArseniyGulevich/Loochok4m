import Foundation

// MARK: - Typealias
typealias TokenData = (tokenAccess: String, tokenRefresh: String)
typealias HandlerVoid = () -> Void

// MARK: - TypePost
/*[TutorialPost, IdeaPost]*/
public enum TypePost: String, Codable, CaseIterable {
    case tutorial = "TutorialPost"
    case idea = "IdeaPost"
    
    var id: String { return self.rawValue }
    
    static var list: [TypePost] { return TypePost.allCases }
    static func getById(_ id: String?) -> TypePost? {
        guard let id else { return nil }
        return TypePost.list.first(where: {$0.id == id})
    }
}
