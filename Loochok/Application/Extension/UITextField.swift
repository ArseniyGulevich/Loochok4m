import UIKit

// MARK: - Helper
extension UITextField {
    var isEmpty: Bool { return (self.text ?? "").isEmpty }
    var textStr: String { return self.text ?? "" }
    func textLimit(_ newText: String, _ limit: Int) -> Bool {
        let text = self.text ?? ""
        let isAtLimit = text.count + newText.count <= limit
        return isAtLimit
    }
}

// MARK: - PlaceholderColor
extension UITextField {
    func placeholderColorFont(_ color: UIColor?, _ font: UIFont?) {
        guard let textString = self.placeholder else { return }
        let attrText = NSMutableAttributedString(string: textString)
        let range = NSRange(location: 0, length: attrText.length)
        if let color = color { attrText.addAttribute(.foregroundColor, value: color, range: range) }
        if let font = font { attrText.addAttribute(.font, value: font, range: range) }
        self.attributedPlaceholder = attrText
    }
}

// MARK: - Padding
extension UITextField {
    func setPadding(_ padding: CGFloat) {
        setLeftPadding(padding)
        setRightPadding(padding)
    }
    func setLeftPadding(_ padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPadding(_ padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

// MARK: - Toolbar
extension UITextField {
    // MARK: Toolbar
    func addInputAccessoryView(title: String = "Готово", target: Any, selector: Selector) {
        let toolbarCGRect = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 44.0)
        let toolBar = UIToolbar(frame: toolbarCGRect)
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(title: title, style: .done, target: target, action: selector)
        toolBar.setItems([flexible, barButton], animated: false)
        toolBar.tintColor = UIColor("000000")
        self.inputAccessoryView = toolBar
    }
    /*
     self.myTextField.addInputAccessoryView(title: "Done", target: self, selector: #selector(tapDone))
     @objc func tapDone() { self.view.endEditing(true) }
     */
}
