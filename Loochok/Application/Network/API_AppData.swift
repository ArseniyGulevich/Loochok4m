import Foundation

// MARK: - load_Data
extension API {
    static func load_Data_User(closure: @escaping (_ error: ErrorApp?) -> ()) {
        API.userMe { (result) in
            switch result {
            case .failure(let error): closure(error)
            case .success(let user):
                appService.user = user
                closure(nil)
                print("👉 load userMe: \(user.id)")
            }
        }
    }
    static func load_Data_Shop(closure: @escaping (_ error: ErrorApp?) -> ()) {
        let dispatchGroup = DispatchGroup()
        
//        // postList
//        dispatchGroup.enter()
//        API.postList { (result) in
//            switch result {
//            case .failure(let error): print(error)
//            case .success(let list):
//                appService.postList = list
//                print("👉 load postList: \(list.count)")
//            }
//            dispatchGroup.leave()
//        }

        // Total
        dispatchGroup.notify(queue: DispatchQueue.main) {
            closure(nil)
            print("👉 notify: load_Data_Shop")
        }
    }
}
