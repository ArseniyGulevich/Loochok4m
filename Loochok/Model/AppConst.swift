import UIKit

let appConst = AppConst.shared
class AppConst {
    static let shared = AppConst()
    
    // MARK: Constants
}

// MARK: - UIFont
extension UIFont {
    static func suisseIntlR(_ size: CGFloat) -> UIFont {
        return UIFont(name: "SuisseIntl-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    static func sfProDisplayR(_ size: CGFloat) -> UIFont {
        return UIFont(name: "SFProDisplay-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    static func sfProDisplayM(_ size: CGFloat) -> UIFont {
        return UIFont(name: "SFProDisplay-Medium", size: size) ?? UIFont.systemFont(ofSize: size)
    }
}

// MARK: - UIColor
extension UIColor {
    static let main: UIColor = UIColor("2C2D2E")
}

// MARK: - UIImage
extension UIImage {
}
