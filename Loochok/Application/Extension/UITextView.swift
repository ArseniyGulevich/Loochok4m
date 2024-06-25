import UIKit

// MARK: - Helper
extension UITextView {
    var textStr: String { return self.text ?? "" }
    var isEmpty: Bool { return (self.text ?? "").isEmpty }
}

// MARK: - Toolbar
extension UITextView {
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
}
