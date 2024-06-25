import Foundation

// MARK: - User data
extension API {
    // profile / user data
    static func userMe(onResult: @escaping (Result<User, ErrorApp>)->()) {
        //noAPI
        guard let user = ldService.user
        else { onResult(.failure(.invalidJSON("userMe"))); return }
        onResult(.success(user))
        //
//        // {{host}}/v1/users/me
//        
//        let method = MethodAPI()
//        method.path = "/v1/users/me"
//        method.method = .get
//        method.parameters = nil
//        //method.printInfo()
//        
//        RouteAPI().request(method) { (route) in
//            //printJSONString(route.dict, method.description)
//            if let error = route.error { onResult(.failure(error)); return }
//            guard route.isSuccessful else { onResult(.failure(ErrorApp.setup(route))); return }
//            
//            guard let user = User(json: route.dict.json("data"))
//            else { onResult(.failure(.invalidJSON(method.path))); return }
//            onResult(.success(user))
//        }
    }
    // userUpdate
    static func userUpdate(_ dict: JSON, onResult: @escaping (Result<User, ErrorApp>)->()) {
        //noAPI
        appService.user.info = dict.string("info")
        ldService.user = appService.user
        onResult(.success(appService.user))
        //
//        // {{host}}/v1/users/me
//
//        let method = MethodAPI()
//        method.path = "/v1/users/me"
//        method.method = .put
//        method.parameters = dict
//        //method.printInfo()
//
//        RouteAPI().request(method) { (route) in
//            if let error = route.error { onResult(.failure(error)); return }
//            guard route.isSuccessful else { onResult(.failure(ErrorApp.setup(route))); return }
//            
//            guard let user = User(json: route.dict.json("data"))
//            else { onResult(.failure(.invalidJSON(method.path))); return }
//            onResult(.success(user))
//        }
    }
}
