import UIKit

class RegProfileViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var infoTextField: UITextField_app!
    // MARK: - IBAction
    @IBAction func nextButtonPressed(_ sender: UIButton) { saveData() }
    @IBAction func skipButtonPressed(_ sender: UIButton) { appRoute.setRootVC_introVC() }
    // MARK: - Variables UI
    var imagePicker: ImagePicker?
    // MARK: - Variables
    var mData: MediaData?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardOnTapAround()
        setupTapGestureRecognizer()
        setupTextField()
        setup_imagePicker()
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
        //nextButton.stateBtn = isValidData(false, false) ? .inac : .off
    }

    // MARK: - Navigation
}

// MARK: - UITapGestureRecognizer
extension RegProfileViewController {
    private func setupTapGestureRecognizer() {
        photoImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedOn_photoImageView)))
        photoImageView.isUserInteractionEnabled = true
    }
    @objc private func tappedOn_photoImageView(_ gestureRecognizer: UITapGestureRecognizer) {
        imagePicker?.goToMenuActionVC()
    }
}

// MARK: - UITextFieldDelegate
extension RegProfileViewController: UITextFieldDelegate {
    private func setupTextField() {
        
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
        case infoTextField: dismissKeyboard()
        default: ()
        }
        return true
    }
}

// MARK: - photo
extension RegProfileViewController {
    private func setup_imagePicker(selectionMedia: ImagePicker.SelectionMedia = .image, selectionLimit: Int? = 1) {
        dismissKeyboard()
        imagePicker = ImagePicker(sourceVC: self, selectionMedia: selectionMedia, selectionLimit: selectionLimit)
        imagePicker?.didSelectMediaDataList = { (mdList) in self.didSelectMediaDataList(mdList) }
    }
    private func didSelectMediaDataList(_ mdList: [MediaData]) {
        guard let mData = mdList.first else { return }
        self.mData = mData
        photoImageView.image = mData.image?.cropToSquare()
        photoImageView.round_iv(35)
        setupUI_nextButton()
    }
}

// MARK: API
extension RegProfileViewController {
    private func isValidData(_ isShowAlert: Bool = true, _ isShowTF: Bool = true) -> Bool {
        var isValid: Bool = true
        let textError = ""
        
        if (infoTextField.text ?? "").isEmpty {
            isValid = false
            if isShowTF { infoTextField.showError("Обязательное поле") }
        }
        
        if isShowAlert && !isValid && !textError.isEmpty { self.displayAlert("Внимание", textError) }

        return isValid
    }
    // saveData
    private func saveData() {
        dismissKeyboard()
        guard isValidData(true, true) else { return }

        var dict: JSON = [:]
        dict["info"] = infoTextField.text

        self.hudShow()
        API.userUpdate(dict) { [weak self] (result) in
            guard let sSelf = self else { return }
            sSelf.hudHide()
            switch result {
            case .failure(let error): error.run(sSelf)
            case .success(let user):
                appService.user = user
                appRoute.setRootVC_introVC()
            }
        }
        
        if let image = mData?.image { appService.userAva = image }
    }
}
