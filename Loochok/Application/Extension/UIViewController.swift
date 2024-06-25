import UIKit

// MARK: - Keyboard
extension UIViewController: UIGestureRecognizerDelegate {
    func hideKeyboardOnTapAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() { view.endEditing(true) }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is UIButton { return false }
        return true
    }
}

// MARK: - Notification Keyboard funcs
extension UIViewController {
    func setupNotificationObserversOfKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func removeNotificationObserversOfKeyboard() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleKeyboardShow(notification: NSNotification){
        //guard let kybFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        //scrollView.contentInset.bottom = view.convert(kybFrame, from: nil).size.height
    }

    @objc func handleKeyboardHide(notification: NSNotification){
        //scrollView.contentInset.bottom = 0
    }
}

// MARK: - present
@nonobjc extension UIViewController {
    // MARK: - Navigation
    func present(_ vc: UIViewController, _ modalPresentationStyle: UIModalPresentationStyle = .fullScreen, _ animated: Bool = true) {
        vc.modalPresentationStyle = modalPresentationStyle
        self.present(vc, animated: animated, completion: nil)
    }
    // navigationController
    func pushVC(_ vc: UIViewController, _ animated: Bool = true) {
        self.navigationController?.pushViewController(vc, animated: animated)
    }
    func popVC(_ animated: Bool = true) {
        self.navigationController?.popViewController(animated: animated)
    }
    func popToRootVC(_ animated: Bool = true) {
        self.navigationController?.popToRootViewController(animated: animated)
    }
    func dismiss(_ animated: Bool = true) { self.dismiss(animated: animated, completion: nil) }
    // MARK: - PopUp
    func presentPopUp(_ child: UIViewController, _ frame: CGRect? = nil) {
        addChild(child)
        if let frame = frame { child.view.frame = frame }
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    func removePopUp() {
        guard parent != nil else { return }
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
    
// MARK: - Alert
typealias AlertActionBlock = (UIAlertController) -> Void
extension UIViewController {
    //
    func showAlert(withTitle title: String? = .none, message: String? = .none, style: UIAlertController.Style = .actionSheet, actionBlock: AlertActionBlock) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        alertController.popoverPresentationController?.sourceView = view
        alertController.view.tintColor = view.tintColor
        actionBlock(alertController)
        
        dqMainAsync { self.present(alertController, animated: true, completion: nil) }
    }
    // MARK: - Вывод предупреждений и сообщений об ошибках
    func displayAlert(_ title: String?, _ message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func displayAlertCompletion(_ title: String?, _ message: String?, _ btnTitle: String = "OK", completion: @escaping () -> ()) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionOK = UIAlertAction(title: btnTitle, style: .default) { (_) in
            completion()
        }
        alertVC.addAction(actionOK)
        self.present(alertVC, animated: true, completion: nil)
    }
    func displayAlertYesNo(_ title: String?, _ message: String?, btnNo: String = "Нет", btnYes: String = "Да", completion: @escaping (_ isYes: Bool) -> ()) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionYes = UIAlertAction(title: btnYes, style: .default) { (_) in completion(true) }
        let actionNo = UIAlertAction(title: btnNo, style: .default) { (_) in completion(false) }
        alertVC.addAction(actionNo)
        alertVC.addAction(actionYes)
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func displayAlertYesNo(_ title: String?, _ message: String?,
                           _ btnNo: String = "Нет", _ btnYes: String = "Да",
                           styleNo: UIAlertAction.Style = .default,
                           styleYes: UIAlertAction.Style = .default,
                           completion: @escaping (_ isYes: Bool) -> ()) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionYes = UIAlertAction(title: btnYes, style: styleYes) { (_) in completion(true) }
        let actionNo = UIAlertAction(title: btnNo, style: styleNo) { (_) in completion(false) }
        
        alertVC.addAction(actionNo)
        alertVC.addAction(actionYes)
        
        DispatchQueue.main.async { self.present(alertVC, animated: true, completion: nil) }
    }
}

// MARK: - MBProgressHUD
import MBProgressHUD
extension UIViewController {
    func hudShow(title: String = "", description: String = "") {
        let indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
        indicator.mode = .indeterminate
        indicator.label.text = title
        indicator.isUserInteractionEnabled = true
        indicator.detailsLabel.text = description
        indicator.contentColor = UIColor("000000")
        indicator.show(animated: true)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    func hudHide() {
        MBProgressHUD.hide(for: self.view, animated: true)
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

// MARK: - MBProgressHUD
extension UIView {
    func hudShow(_ title: String = "", _ description: String = "") {
        let indicator = MBProgressHUD.showAdded(to: self, animated: true)
        indicator.mode = .indeterminate
        indicator.label.text = title
        indicator.isUserInteractionEnabled = true
        indicator.detailsLabel.text = description
        indicator.contentColor = UIColor("000000")
        indicator.show(animated: true)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    func hudHide() {
        MBProgressHUD.hide(for: self, animated: true)
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
