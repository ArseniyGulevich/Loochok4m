import Foundation

let ldService = LDService.shared
class LDService {
    // MARK: Enum
    private enum UDKey: String, CaseIterable {
        case isWasIntro
        case tokenAccess
        case tokenRefresh
        // Extra
        case user
        
        var key: String { return self.rawValue }
    }
    // MARK: Constant
    static let shared = LDService()
    private let userDefaults: UserDefaults
    
    // MARK: - Initializers
    private init() {
        self.userDefaults = UserDefaults.standard
    }
    deinit {}
    
    // All
    class func removeAll() {
        let userDefaults = UserDefaults.standard
        UDKey.allCases.forEach { userDefaults.removeObject(forKey: $0.rawValue) }
        userDefaults.synchronize()
    }
}

// MARK: - App
extension LDService {
    var isWasIntro: Bool {
        get { return userDefaults.bool(forKey: UDKey.isWasIntro.key) }
        set { userDefaults.set(newValue, forKey: UDKey.isWasIntro.key) }
    }
    var tokenAccess: String? {
        get { return userDefaults.string(forKey: UDKey.tokenAccess.key) }
        set {
            userDefaults.set(newValue, forKey: UDKey.tokenAccess.key)
            userDefaults.synchronize()
        }
    }
    var tokenRefresh: String? {
        get { return userDefaults.string(forKey: UDKey.tokenRefresh.key) }
        set {
            userDefaults.set(newValue, forKey: UDKey.tokenRefresh.key)
            userDefaults.synchronize()
        }
    }
}

// MARK: - Extra-noAPI
extension LDService {
    var user: User? {
        get {
            guard let json = userDefaults.object(forKey: UDKey.user.key) as? JSON
            else { return nil }
            let item = parseDict<User>().getObject(json)
            return item
        }
        set {
            let json = newValue?.json
            userDefaults.set(json, forKey: UDKey.user.key)
            userDefaults.synchronize()
        }
    }
}
