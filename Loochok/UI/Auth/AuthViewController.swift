import UIKit

class AuthViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var emailTextField: UITextField_app!
    @IBOutlet weak var pswTextField: UITextField_app!
    // MARK: - IBAction
    @IBAction func restorePswButtonPressed(_ sender: UIButton) { goToRestorePswVC() }
    @IBAction func nextButtonPressed(_ sender: UIButton) { auth_email() }
    @IBAction func goToRegButtonPressed(_ sender: UIButton) { goToRegVC() }
    // MARK: - Variables
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardOnTapAround()
        setupTextField()
        setupUI()
        setupFormData()
    }
    
    // MARK: - setupFormData
    private func setupFormData() {
    }
    
    // MARK: - Actions

    // MARK: - SetupUI
    private func setupUI() {
    }
    private func setupUI_nextButton() {
    }

    // MARK: - Navigation
    private func goToRestorePswVC() {
        
    }
    private func goToRegVC() {
        appRoute.setRootVC_regVC()
    }
}

// MARK: - UITextFieldDelegate
extension AuthViewController: UITextFieldDelegate {
    private func setupTextField() {
        emailTextField.validType = .email
        pswTextField.typeTF = .psw
        pswTextField.validType = .psw
        
        let tfList = self.view.getSubviewsOfView(type: UITextField_app.self, recursive: true)
        tfList.forEach { (textField) in
            textField.delegate = self
            textField.setupUI_titleLabel()
            textField.errorLabel?.text = nil
            textField.didUpdate = { self.setupUI_nextButton() }
            textField.didUpdateEnd = { self.setupUI_nextButton() }
        }
    }
    @objc func tapDone() { dismissKeyboard() }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField: pswTextField.becomeFirstResponder()
        case pswTextField: dismissKeyboard()
        default: ()
        }
        return true
    }
}

// MARK: API
extension AuthViewController {
    private func isValidData(_ isShowAlert: Bool = true, _ isShowTF: Bool = true) -> Bool {
        var isValid: Bool = true
        let textError = ""
        
        if let errorTF = Validator().email_error(emailTextField.text) {
            isValid = false
            if isShowTF { emailTextField.showError(errorTF) }
        }
        if let errorTF = Validator().psw_error(pswTextField.text) {
            isValid = false
            if isShowTF { pswTextField.showError(errorTF) }
        }
        
        if isShowAlert && !isValid && !textError.isEmpty { self.displayAlert("Внимание", textError) }

        return isValid
    }
    // auth_email
    private func auth_email() {
        dismissKeyboard()
        guard isValidData(true, true) else { return }

        var dict: JSON = [:]
        dict["email"] = Validator().email_clear(emailTextField.text)
        dict["password"] = pswTextField.text

        self.hudShow()
        API.auth_email(dict) { [weak self] (result) in
            guard let sSelf = self else { return }
            sSelf.hudHide()
            switch result {
            case .failure(let error): error.run(sSelf)
            case .success(let tokenData): appService.finishAuth(tokenData, sSelf)
            }
        }
    }
}
