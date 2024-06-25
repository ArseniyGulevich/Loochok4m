import Foundation

// MARK: - Auth
extension API {
    // reg_email
    static func reg_email(_ dict: JSON, onResult: @escaping (Result<TokenData, ErrorApp>)->()) {
        var userDict: JSON = dict
        userDict["id"] = 1
        guard let user = User(json: userDict)
        else { onResult(.failure(.invalidJSON("reg_email"))); return }
        ldService.user = user
        let tokenData = TokenData("8c71db92-7202-4358-abde-c5817e448b0a", "")
        onResult(.success(tokenData))
        //
        // {{host}}/v1/auth
        
//        let method = MethodAPI()
//        method.path = "/v1/auth/register"
//        method.method = .post
//        method.parameters = dict
//        
//        RouteAPI().request(method) { (route) in
//            if let error = route.error { onResult(.failure(error)); return }
//            guard route.isSuccessful else { onResult(.failure(ErrorApp.setup(route))); return }
//            
//            guard let dict = route.dict.json("data"),
//                  let tokenAccess = dict.string("accessToken"),
//                  let tokenRefresh = dict.string("refreshToken")
//            else { onResult(.failure(.invalidJSON(method.path))); return }
//            let tokenData = TokenData(tokenAccess, tokenRefresh)
//            onResult(.success(tokenData))
//        }
    }
    // auth_email
    static func auth_email(_ dict: JSON, onResult: @escaping (Result<TokenData, ErrorApp>)->()) {
        //noAPI
        guard let email = dict.string("email"), let password = dict.string("password")
        else { onResult(.failure(.invalidJSON("auth_email"))); return }
        
        guard let user = ldService.user, user.email == email, user.psw == password
        else { onResult(.failure(.custom("Пользователь не найден, проверьте адрес электронной почты и пароль"))); return }
        let tokenData = TokenData("8c71db92-7202-4358-abde-c5817e448b0a", "")
        onResult(.success(tokenData))
        //
//        // {{host}}/v1/auth
//        
//        let method = MethodAPI()
//        method.path = "/v1/auth/login"
//        method.method = .post
//        method.parameters = dict
//        //method.printInfo()
//        
//        RouteAPI().request(method) { (route) in
//            if let error = route.error { onResult(.failure(error)); return }
//            guard route.isSuccessful else { onResult(.failure(ErrorApp.setup(route))); return }
//            
//            guard let dict = route.dict.json("data"),
//                  let tokenAccess = dict.string("accessToken"),
//                  let tokenRefresh = dict.string("refreshToken")
//            else { onResult(.failure(.invalidJSON(method.path))); return }
//            let tokenData = TokenData(tokenAccess, tokenRefresh)
//            onResult(.success(tokenData))
//        }
    }
}
