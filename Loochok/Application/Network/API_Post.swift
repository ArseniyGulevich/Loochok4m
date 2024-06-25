import Foundation

// MARK: - Posts
extension API {
    // postList
    static func postList(_ dict: JSON = [:], onResult: @escaping (Result<[Post], ErrorApp>)->()) {
        // http://178.250.152.108:3000/api/v1/posts
        
        let method = MethodAPI()
        method.path = "posts" + dict.queryString
        method.method = .get
        method.parameters = nil
        
        RouteAPI().request(method) { (route) in
            //printJSONString(route.dict, method.description)
            if let error = route.error { onResult(.failure(error)); return }
            guard route.isSuccessful else { onResult(.failure(ErrorApp.setup(route))); return }
            
            var list = Post.loadList(route.dict.jsonList("posts"))
            if let userId = dict.integer("userId") {
                list = list.filter { $0.user.id == userId }
            }
            onResult(.success(list))
        }
    }
}

// MARK: - Posts-comment
extension API {
    // commentList
    static func commentList(_ dict: JSON = [:], onResult: @escaping (Result<[Comment], ErrorApp>)->()) {
        // http://178.250.152.108:3000/api/v1/comments
        
        let method = MethodAPI()
        method.path = "comments" + dict.queryString
        method.method = .get
        method.parameters = nil
        
        RouteAPI().request(method) { (route) in
            //printJSONString(route.dict, method.description)
            if let error = route.error { onResult(.failure(error)); return }
            guard route.isSuccessful else { onResult(.failure(ErrorApp.setup(route))); return }
            
            var list = Comment.loadList(route.dictList)
            if let postId = dict.integer("postId") {
                list = list.filter { $0.postId == postId }
            }
            onResult(.success(list))
        }
    }
}
