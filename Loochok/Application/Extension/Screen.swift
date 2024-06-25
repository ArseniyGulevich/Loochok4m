import UIKit

struct Screen {
    static var width: CGFloat { return UIScreen.main.bounds.width }
    static var height: CGFloat { return UIScreen.main.bounds.height }
    static var scale: CGFloat { return UIScreen.main.scale }
    
    // statusBarHeight
    static var sbH: CGFloat {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
            return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }
    // topSafeArea
    static var saT: CGFloat {
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            return window?.safeAreaInsets.top ?? 0
        } else {
            let root = UIApplication.shared.keyWindow?.rootViewController
            return root?.topLayoutGuide.length ?? 0
        }
    }
    // bottomSafeArea
    static var saB: CGFloat {
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            return window?.safeAreaInsets.bottom ?? 0
        } else {
            let root = UIApplication.shared.keyWindow?.rootViewController
            return root?.bottomLayoutGuide.length ?? 0
        }
    }
    // tabBarHeight
    static func tbH(_ vc: UIViewController) -> CGFloat {
        return vc.tabBarController?.tabBar.frame.height ?? 0
    }
    static func workH(_ vc: UIViewController) -> CGFloat {
        return (Screen.height - Screen.saT - Screen.tbH(vc))
    }
    static var workH_withTabBar: CGFloat {
        return (Screen.height - Screen.saT - (appService.tbVC?.tabBar.frame.height ?? 0))
    }
}
