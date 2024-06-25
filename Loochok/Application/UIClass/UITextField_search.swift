import UIKit

class UITextField_search: UITextField {
    // MARK: Public Properties - UI
    // MARK: Public Properties - Data
    // MARK: Public Action
    var didUpdate: (()->Void)?
    // MARK: Private Properties
    
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
    }
}

// MARK: - setupViews
extension UITextField_search: UITextFieldDelegate {
    private func setup_textField() {
        // property
        self.placeholderColorFont(UIColor("828283"), UIFont.suisseIntlR(16))
        self.decorateView_roundBorder(8, UIColor("000000"), 1)
        // action
        self.addTarget(self, action: #selector(self.didEditBegin), for: .editingDidBegin)
        self.addTarget(self, action: #selector(self.didEditingChanged), for: .editingChanged)
        self.addTarget(self, action: #selector(self.didEditEnd), for: .editingDidEnd)
        //
        setAlwaysLeftView()
        setAlwaysRightView()
    }
    func setAlwaysLeftView() {
        let frame = CGRect(x: 0, y: 0, width: 34, height: bounds.height)
        let view = UIView(frame: frame)
        view.backgroundColor = .clear
        
        let imageView = UIImageView(frame: CGRect(x: 8, y: (bounds.height-26)/2, width: 26, height: 26))
        imageView.image = UIImage(named: "searchTF")
        view.addSubview(imageView)
        
        leftView = view
        leftViewMode = .always
    }
    func setAlwaysRightView() {
        let frame = CGRect(x: 0, y: 0, width: 40, height: bounds.height)
        let view = UIView(frame: frame)
        view.backgroundColor = .clear
        
        let button = UIButton(frame: CGRect(x: 10, y: (bounds.height-16)/2, width: 16, height: 16))
        button.setImage(UIImage(named: "clearText"), for: .normal)
        button.addTarget(self, action: #selector(tap_clearButton), for: .touchUpInside)
        view.addSubview(button)
        
        rightView = view
        rightViewMode = self.isEmpty ? .never : .always //.whileEditing
    }
    // MARK: - Actions
    @objc func tap_clearButton(sender: UIButton!) {
        self.text = nil
        setAlwaysRightView()
        self.didUpdate?()
    }
    @objc private func didEditBegin() {
    }
    @objc private func didEditingChanged() {
        setAlwaysRightView()
        self.didUpdate?()
    }
    @objc private func didEditEnd() {
    }
}
