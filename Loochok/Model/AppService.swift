import UIKit

let appService = AppService.shared
class AppService {
    // MARK: Constant
    static let shared = AppService()
    // MARK: Variables Data
    var isDebug: Bool = false
    // Auth
    var tokenAccess: String?
    var user: User!
    // User - data
    var userAva: UIImage? = UIImage(named: "userAva_fake")
    // Shop
    // UI
    var tbVC: UITabBarController? = nil
}

// MARK: - Token
extension AppService {
    var token_isExist: Bool {
        guard let tokenAccess = tokenAccess, !tokenAccess.isEmpty else { return false }
        return true
    }
    func token_save(_ tokenAccess: String?, _ tokenRefresh: String?) {
        self.tokenAccess = tokenAccess
        ldService.tokenAccess = tokenAccess
        ldService.tokenRefresh = tokenRefresh
    }
    func token_load() {
        self.tokenAccess = ldService.tokenAccess
    }
}

// MARK: - setup_AppData
extension AppService {
    public func load_AppData_Locally() {
        // Token
        token_load()
    }
    public func setup_AppData_Shop(closure: @escaping (_ error: ErrorApp?) -> ()) {
        load_AppData_Locally()
        API.load_Data_Shop { (error) in closure(error) }
    }
    public func setupAppData_User(closure: @escaping (_ error: ErrorApp?) -> ()) {
        API.load_Data_User { (error) in
            if error != nil { User.signOut(); print("👿 Error 'setupAppData_User': \(error!.text)") }
            print(" 😻😻😻😻😻 ")
            print(" userId: \(appService.user?.id ?? 0)")
            print(" name: \(String(describing: appService.user?.name ?? ""))")
            print(" token: \(appService.tokenAccess ?? "no token")")
            print(" 😻😻😻😻😻 ")
            
            closure(error)
        }
    }
    //
    public func finishAuth(_ tokenData: TokenData, _ sourceVC: UIViewController, _ withGoToApp: Bool = true, closure: (()->())? = nil) {
        appService.token_save(tokenData.tokenAccess, tokenData.tokenRefresh)

        sourceVC.hudShow()
        setupAppData_User { (error) in
            sourceVC.hudHide()
            if let error = error { error.run(sourceVC); return }
            
            if withGoToApp { appRoute.goToApp() }
            closure?()
        }
    }
}
