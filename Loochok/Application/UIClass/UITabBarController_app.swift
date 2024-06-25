import UIKit

class UITabBarController_app: UITabBarController {
    // MARK: - Variables
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup_tabBarController()
        setupUI()
        setupFormData()
    }
    
    // MARK: - setupFormData
    public func setupFormData(_ selIndex: Int? = nil) {
        //if let selIndex = selIndex { self.selectedIndex = selIndex }
    }
    
    // MARK: - SetupUI
    private func setupUI() {
    }
}

// MARK: -
extension UITabBarController_app {
    private func setup_tabBarController() {
        self.delegate = self
    }
}

// MARK: - UITabBarControllerDelegate
extension UITabBarController_app: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController)
        else { return true }
        print(selectedIndex)
        if selectedIndex == 2 { goToMenuAddVC(); return false }
        return true
    }
}

// MARK: - Navigation
extension UITabBarController_app {
    private func goToMenuAddVC() {
        self.tabBar.items?.at(2)?.image = .tbAdd1
        let vc: MenuAddViewController = UIStoryboard.controller(.main)
        vc.constrB = self.tabBar.frame.height+24
        vc.didSelect = { (menuTag) in
            guard let topVC = UIApplication.getTopVC() else { return }
            switch menuTag {
            case 1:
                let vc: RedactorViewController = UIStoryboard.controller(.redactor)
                vc.modeVC = .tutorial
                topVC.present(vc, .formSheet, true)
            case 2:
                let vc: RedactorViewController = UIStoryboard.controller(.redactor)
                vc.modeVC = .idea
                topVC.present(vc, .formSheet, true)
            default: break
            }
            self.tabBar.items?.at(2)?.image = .tbAdd0
        }
        self.presentPopUp(vc)
    }
}
