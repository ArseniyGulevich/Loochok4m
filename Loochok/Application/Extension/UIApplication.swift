import UIKit

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) { return UIApplication.shared.windows.first { $0.isKeyWindow } }
        else { return UIApplication.shared.keyWindow }
    }
}

// MARK: - topViewController
extension UIApplication {
    class func getTopVC(base: UIViewController? = UIWindow.key?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopVC(base: nav.visibleViewController)
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopVC(base: selected)
        } else if let presented = base?.presentedViewController {
            return getTopVC(base: presented)
        } else if let child = base?.children.last {
            return getTopVC(base: child)
        } else { return base }
    }
}
