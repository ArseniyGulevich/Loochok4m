import UIKit

class UITextField_app: UITextField {
    // MARK: Public Properties - UI
    // MARK: Public Properties - Data
    public var typeTF: TypeTF = .idle { didSet { setup_textField_typeTF() } }
    public var validType: Validator.TypeData? = nil //{ didSet { updateValidType() } }
    public var simpleTextError: String? = "Обязательно для заполнения"
    // MARK: Public Action
    var didUpdate: (()->Void)?
    var didUpdateEnd: (()->Void)?
    var didTapButtonL: (()->Void)?
    var didTapButtonR: (()->Void)?
    // MARK: Private Properties
    private var stateTF: StateTF = .idle { didSet { setupUI_stateTF() } }
    // MARK: Private UI Properties
    private(set) lazy var buttonR: UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0,
                              y: CGFloat((self.frame.size.height - 30)/2),
                              width: 30, height: 30)
        button.addTarget(self, action: #selector(tap_buttonR), for: .touchUpInside)
        return button
    }()
    var boxView: UIStackView? { self.superview as? UIStackView }
    var titleLabel: UILabel? { self.superview?.getSubviewsOfView(type: UILabel.self, recursive: false).first(where: { $0.tag == 777 }) }
    var errorLabel: UILabel? { self.superview?.getSubviewsOfView(type: UILabel.self, recursive: false).first(where: { $0.tag == 666 }) }
    
    // MARK: - Initializers
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
        
    // MARK: Private Methods
    private func setupViews() {
        setup_textField()
        setupUI_stateTF()
    }
    private func setupUI_stateTF() {
        //titleLabel?.textColor = stateTF.colorTitle
        // errorLabel
        switch stateTF {
        case .error(let textError): showHideError(textError)
        default: showHideError(nil)
        }
    }
}

// MARK: - setupViews
extension UITextField_app: UITextFieldDelegate {
    private func setup_textField() {
        // property
        self.placeholderColorFont(UIColor("828283"), UIFont.suisseIntlR(16))
        self.decorateView_roundBorder(8, UIColor("000000"), 1)
        self.setPadding(16)
        // action
        self.addTarget(self, action: #selector(self.didEditBegin), for: .editingDidBegin)
        self.addTarget(self, action: #selector(self.didEditingChanged), for: .editingChanged)
        self.addTarget(self, action: #selector(self.didEditEnd), for: .editingDidEnd)
        
        setup_textField_typeTF()
    }
    // MARK: - Actions
    @objc private func didEditBegin() {
        stateTF = .active
    }
    @objc private func didEditingChanged() {
        setupUI_titleLabel()
        self.didUpdate?()
    }
    @objc private func didEditEnd() {
        setupUI_titleLabel()
        validationIfNeed()
        self.didUpdateEnd?()
    }
    private func validationIfNeed() {
        guard let validType = validType else { stateTF = .idle; showHideError(nil); return }
        switch validType {
        case .simple:
            let errorStr = simpleTextError ?? (self.placeholder ?? "")
            stateTF = self.isEmpty ? .error(errorStr) : .valid
        case .email:
            let errorStr = Validator().email_error(self.text)
            stateTF = (errorStr == nil) ? .valid : .error(errorStr)
        case .psw:
            let errorStr = Validator().psw_error(self.text)
            stateTF = (errorStr == nil) ? .valid : .error(errorStr)
        }
    }
    // error
    private func showHideError(_ error: String?) {
        errorLabel?.text = error
        errorLabel?.isHidden = (error ?? "").isEmpty
    }
}

// MARK: - Left/RightView
extension UITextField_app {
    private func setup_textField_typeTF() {
        // AnyFormatKit
        switch typeTF {
        case .idle: ()
        case .psw:
            buttonR.setImage(UIImage(named: "eye0"), for: .normal)
            self.setRightPadding(30+16)
            
            let rpView = UIView(frame: CGRect(x: self.frame.size.width-(30+16), y: 0,
                                              width: 30+16, height: self.frame.size.height))
            rpView.backgroundColor = .clear
            rpView.addSubview(buttonR)
            self.rightView = rpView
            self.rightViewMode = .always
        }
    }
    @objc private func tap_buttonL() { self.didTapButtonL?() }
    @objc private func tap_buttonR() {
        if validType == .psw { showHidePsw() }
        self.didTapButtonR?()
    }
    @objc private func showHidePsw() {
        self.isSecureTextEntry = !self.isSecureTextEntry
        buttonR.setImage(UIImage(named: "eye\(self.isSecureTextEntry ? 0 : 1)"), for: .normal)
    }
}

// MARK: - Public Functions
extension UITextField_app {
    public func showError(_ textError: String?) {
        guard let textError = textError else { return }
        stateTF = .error(textError)
    }
    public func updateStateTF(_ newState: StateTF) {
        stateTF = newState
    }
    // setupUI_titleLabel
    public func setupUI_titleLabel() {
        //titleLabel?.alpha = self.isEmpty ? 0 : 1
    }
}

// MARK: - Enums
extension UITextField_app {
    // StateTF
    enum StateTF {
        case idle
        case active
        case valid
        case error(String?)
        
        var colorTitle: UIColor {
            switch self {
            case .idle, .valid: return UIColor("2C2D2E")
            case .active: return UIColor("000000")
            case .error: return UIColor("DE4040")
            }
        }
        var colorBorder: UIColor {
            switch self {
            case .idle, .valid: return UIColor("000000")
            case .active: return UIColor("000000")
            case .error: return UIColor("DE4040")
            }
        }
    }
    enum TypeTF {
        case idle
        case psw
    }
}
