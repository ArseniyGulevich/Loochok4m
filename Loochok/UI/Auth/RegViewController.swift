import UIKit

class RegViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameTextField: UITextField_app!
    @IBOutlet weak var emailTextField: UITextField_app!
    @IBOutlet weak var nickTextField: UITextField_app!
    @IBOutlet weak var pswTextField: UITextField_app!
    @IBOutlet weak var pswRTextField: UITextField_app!
    // MARK: - IBAction
    @IBAction func nextButtonPressed(_ sender: UIButton) { reg_email() }
    @IBAction func goToAuthButtonPressed(_ sender: UIButton) { goToAuthVC() }
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
        scrollView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 24, right: 0)
        scrollView.bounces = false
    }
    private func setupUI_nextButton() {
    }

    // MARK: - Navigation
    private func goToAuthVC() {
        appRoute.setRootVC_authVC()
    }
}

// MARK: - UITextFieldDelegate
extension RegViewController: UITextFieldDelegate {
    private func setupTextField() {
        emailTextField.validType = .email
        pswTextField.typeTF = .psw
        pswTextField.validType = .psw
        pswRTextField.typeTF = .psw
        pswRTextField.validType = .psw
        
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
        case nameTextField: emailTextField.becomeFirstResponder()
        case emailTextField: nickTextField.becomeFirstResponder()
        case nickTextField: pswTextField.becomeFirstResponder()
        case pswTextField: pswRTextField.becomeFirstResponder()
        case pswRTextField: dismissKeyboard()
        default: ()
        }
        return true
    }
}

// MARK: API
extension RegViewController {
    private func isValidData(_ isShowAlert: Bool = true, _ isShowTF: Bool = true) -> Bool {
        var isValid: Bool = true
        let textError = ""
        
        var textField: UITextField_app = nameTextField
        if (textField.text ?? "").isEmpty {
            isValid = false
            if isShowTF { textField.showError("Обязательное поле") }
        }
        
        if let errorTF = Validator().email_error(emailTextField.text) {
            isValid = false
            if isShowTF { emailTextField.showError(errorTF) }
        }
        
        textField = nickTextField
        if (textField.text ?? "").isEmpty {
            isValid = false
            if isShowTF { textField.showError("Обязательное поле") }
        }
        
        if let errorTF = Validator().psw_error(pswTextField.text) {
            isValid = false
            if isShowTF { pswTextField.showError(errorTF) }
        }
        
        if let errorTF = Validator().psw_error(pswRTextField.text) {
            isValid = false
            if isShowTF { pswRTextField.showError(errorTF) }
        }
        if !pswRTextField.isEmpty && (pswTextField.textStr != pswRTextField.textStr) {
            isValid = false
            if isShowTF { pswRTextField.showError("Пароли не совпадают") }
        }
        
        if isShowAlert && !isValid && !textError.isEmpty { self.displayAlert("Внимание", textError) }

        return isValid
    }
    // reg_email
    private func reg_email() {
        dismissKeyboard()
        guard isValidData(true, true) else { return }

        var dict: JSON = [:]
        dict["name"] = nameTextField.text
        dict["nick"] = nickTextField.text
        dict["email"] = Validator().email_clear(emailTextField.text)
        dict["password"] = pswTextField.text

        self.hudShow()
        API.reg_email(dict) { [weak self] (result) in
            guard let sSelf = self else { return }
            sSelf.hudHide()
            switch result {
            case .failure(let error): error.run(sSelf)
            case .success(let tokenData): appService.finishAuth(tokenData, sSelf)
                appService.finishAuth(tokenData, sSelf, false) {
                    let vc: RegProfileViewController = UIStoryboard.controller(.auth)
                    UIApplication.shared.keyWindow?.rootViewController = vc
                }
            }
        }
    }
}
