import UIKit

class RedactorViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField_app!
    @IBOutlet weak var tagsTextField: UITextField_app!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var infoTextView: UITextView_app!
    // MARK: - IBAction
    @IBAction func backButtonPressed(_ sender: UIButton) { self.dismiss() }
    @IBAction func nextButtonPressed(_ sender: UIButton) { saveData() }
    // MARK: - Enums
    enum ModeVC { case tutorial, idea }
    // MARK: - Variables UI
    var imagePicker: ImagePicker?
    // MARK: - Variables
    var modeVC: ModeVC = .tutorial
    var mData: MediaData?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardOnTapAround()
        setupTapGestureRecognizer()
        setupTextField()
        setupTextView()
        setup_imagePicker()
        setupFormData()
        setupUI()
    }
    
    // MARK: - setupFormData
    private func setupFormData() {
        headerLabel.text = {
            switch self.modeVC {
            case .tutorial: "ТУТОРИАЛ"
            case .idea: "ИДЕЯ"
            }
        }()
    }
    
    // MARK: - Actions

    // MARK: - SetupUI
    private func setupUI() {
        scrollView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 24, right: 0)
        scrollView.bounces = false
        infoView.decorateView_roundBorder(8, UIColor("000000"), 1)
    }

    // MARK: - Navigation
}

// MARK: - UITapGestureRecognizer
extension RedactorViewController {
    private func setupTapGestureRecognizer() {
        photoImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedOn_photoImageView)))
        photoImageView.isUserInteractionEnabled = true
    }
    @objc private func tappedOn_photoImageView(_ gestureRecognizer: UITapGestureRecognizer) {
        imagePicker?.goToMenuActionVC()
    }
}

// MARK: - UITextFieldDelegate
extension RedactorViewController: UITextFieldDelegate {
    private func setupTextField() {
        
        let tfList = self.view.getSubviewsOfView(type: UITextField_app.self, recursive: true)
        tfList.forEach { (textField) in
            textField.delegate = self
            textField.setupUI_titleLabel()
            textField.errorLabel?.text = nil
        }
    }
    @objc func tapDone() { dismissKeyboard() }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField: tagsTextField.becomeFirstResponder()
        case tagsTextField: infoTextView.becomeFirstResponder()
        default: ()
        }
        return true
    }
}

// MARK: - setupTextView
extension RedactorViewController: UITextViewDelegate {
    private func setupTextView() {
        infoTextView.delegate = self
        infoTextView.addInputAccessoryView(title: "Далее", target: self, selector: #selector(tapDone))
    }
}

// MARK: - photo
extension RedactorViewController {
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
    }
}

// MARK: API
extension RedactorViewController {
    private func isValidData(_ isShowAlert: Bool = true, _ isShowTF: Bool = true) -> Bool {
        var isValid: Bool = true
        var textError = ""
        
        if (nameTextField.text ?? "").isEmpty {
            isValid = false
            if isShowTF { nameTextField.showError("Обязательное поле") }
        }
        
        if (tagsTextField.text ?? "").isEmpty {
            isValid = false
            if isShowTF { nameTextField.showError("Введите теги") }
        }
        
        if (infoTextView.text ?? "").isEmpty {
            isValid = false
            textError = "Введите описание"
        }
        
        if isShowAlert && !isValid && !textError.isEmpty { self.displayAlert("Внимание", textError) }

        return isValid
    }
    // saveData
    private func saveData() {
        dismissKeyboard()
        guard isValidData(true, true) else { return }

        var dict: JSON = [:]
        dict["name"] = nameTextField.text
        dict["tags"] = tagsTextField.text
        dict["info"] = infoTextView.text
        
        dismiss()

//        self.hudShow()
//        API.postAdd(dict) { [weak self] (result) in
//            guard let sSelf = self else { return }
//            sSelf.hudHide()
//            switch result {
//            case .failure(let error): error.run(sSelf)
//            case .success(let post):
//                ()
//            }
//        }
    }
}
