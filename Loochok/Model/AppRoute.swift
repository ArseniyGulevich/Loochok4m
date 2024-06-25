import UIKit

let appRoute = AppRoute.shared
class AppRoute {
    // MARK: Constant
    static let shared = AppRoute()
}

// MARK: - setRootVC
extension AppRoute {
    public func setRootVC_welcomeVC() {
        let vc: WelcomeViewController = UIStoryboard.controller(.main)
        UIApplication.shared.keyWindow?.rootViewController = vc
    }
    public func goToApp(_ selectIndex: Int = 0) {
        let tbc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabBar") as! UITabBarController
        tbc.selectedIndex = selectIndex
        UIApplication.shared.keyWindow?.rootViewController = tbc
    }
}

// MARK: - Auth
extension AppRoute {
    public func setRootVC_authVC() {
        let vc: AuthViewController = UIStoryboard.controller(.auth)
        UIApplication.shared.keyWindow?.rootViewController = vc
    }
    public func setRootVC_regVC() {
        let vc: RegViewController = UIStoryboard.controller(.auth)
        UIApplication.shared.keyWindow?.rootViewController = vc
    }
    public func setRootVC_introVC() {
        let vc: IntroViewController = UIStoryboard.controller(.auth)
        UIApplication.shared.keyWindow?.rootViewController = vc
    }
}

// MARK: - Posts
extension AppRoute {
    func goToTutorialVC(_ post: Post) {
        guard let topVC = UIApplication.getTopVC() else { return }
        let vc: TutorialViewController = UIStoryboard.controller(.tutorial)
        vc.post = post
        topVC.pushVC(vc)
    }
    func goToIdeaVC(_ post: Post) {
        guard let topVC = UIApplication.getTopVC() else { return }
        let vc: IdeaViewController = UIStoryboard.controller(.idea)
        vc.post = post
        topVC.pushVC(vc)
    }
}

// MARK: - Test
extension AppRoute {
    func goToTestVC() {
        guard let topVC = UIApplication.getTopVC() else { return }
        let vc: IntroViewController = UIStoryboard.controller(.auth)
        topVC.present(vc)
    }
}
