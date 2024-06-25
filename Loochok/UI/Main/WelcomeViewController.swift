import UIKit

class WelcomeViewController: UIViewController {
    // MARK: - IBOutlet
    // MARK: - IBAction
    // MARK: - Variables
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //LDService.removeAll()
        setupUI()
        setupFormData()
        delay(1) { self.setupAppData() }
    }
    
    // MARK: - setupFormData
    private func setupFormData() {
    }
    
    // MARK: - SetupAppData
    private func setupAppData() {
        guard NetworkState.isConnected else { ErrorApp.noInternet.run(self); return }

        appService.setup_AppData_Shop { [weak self] (error) in
            guard let sSelf = self else { return }
            if let error = error { error.run(sSelf); return }

            guard appService.token_isExist else {
                appRoute.setRootVC_authVC()
                return
            }
            
            appService.setupAppData_User { (error) in
                if let error = error {
                    print(error.text)
                    appRoute.setRootVC_authVC()
                    return
                }
                appRoute.goToApp()
            }
        }
    }
    
    // MARK: - Actions

    // MARK: - SetupUI
    private func setupUI() {
    }

    // MARK: - Navigation
}
