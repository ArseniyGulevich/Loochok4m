import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupDefaultConfigure()
        return true
    }
}

// MARK: UISceneSession Lifecycle
extension AppDelegate {
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

// MARK: - Modes
extension AppDelegate {
}

// MARK: - Helpers
extension AppDelegate {
    private func setupDefaultConfigure() {
        // IQKeyboardManagerSwift
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        
        // Style App
        setDefaultStyle()
    }
    // Style
    private func setDefaultStyle() {
        //
        if #available(iOS 13.0, *) {
            self.window?.overrideUserInterfaceStyle = .light
        }
        // UITabBar
        let colorSelect = UIColor("FFFFFF")
        let colorDefault = UIColor("C9C9C9")
        if #available(iOS 13.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor("000000")
            
            // tabbarItems
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor("828283")
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: colorDefault]
            
            appearance.stackedLayoutAppearance.selected.iconColor = UIColor("FFC700")
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: colorSelect]
            UITabBar.appearance().standardAppearance = appearance
            
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        } else {
            UITabBar.appearance().tintColor = colorSelect
            UITabBar.appearance().unselectedItemTintColor = colorDefault
            UITabBar.appearance().backgroundColor = UIColor("000000")
            //UITabBar.appearance().isTranslucent = false
        }
    }
}
