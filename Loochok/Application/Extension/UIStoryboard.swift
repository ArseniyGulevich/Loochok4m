import UIKit

extension UIStoryboard {
    enum StoryboardEnum: String {
        case main = "Main"
        case home = "Home"
        case tutorial = "Tutorial"
        case redactor = "Redactor"
        case idea = "Idea"
        case profile = "Profile"
        case global = "Global"
        case auth = "Auth"
    }
    //
    class func controller<T: UIViewController>(_ storyboard: StoryboardEnum = StoryboardEnum.main) -> T {
        let identifier = T.className.replacingOccurrences(of: "ViewController", with: "VC")
        return UIStoryboard(name: storyboard.rawValue, bundle: nil).instantiateViewController(withIdentifier: identifier) as! T
    }
    class func initial<T: UIViewController>(_ storyboard: StoryboardEnum) -> T {
        return UIStoryboard(name: storyboard.rawValue, bundle: nil).instantiateInitialViewController() as! T
    }
    class func nc(_ identifier: String, _ storyboard: StoryboardEnum = StoryboardEnum.main) -> UINavigationController {
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! UINavigationController
    }
}

// MARK: - NSObject
extension NSObject {
    class var className: String { return String(describing: self.self) }
}

//https://stackoverflow.com/questions/24494784/get-class-name-of-object-as-string-in-swift
protocol NameDescribable {
    var typeName: String { get }
    static var typeName: String { get }
}
extension NameDescribable {
    var typeName: String { return String(describing: type(of: self)) }
    static var typeName: String { return String(describing: self) }
}
extension NSObject: NameDescribable {}
extension Array: NameDescribable {}
