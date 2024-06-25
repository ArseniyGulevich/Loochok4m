import UIKit

public enum ErrorApp: Error, Equatable {
    static let headerDef: String = "Внимание"
    
    case custom(String)
    case errorApp(String)
    case invalidJSON(String)
    case noInternet
    case refreshToken
    case invalidAuth
    //
}

extension ErrorApp: LocalizedError {
    public var text: String {
        switch self {
        case .custom(let text): return text
        case .errorApp(let text): return text
        case .invalidJSON(let info): return "Invalid JSON: \(info)"
        case .noInternet: return "Отсутствует подключение к Интернету"
        case .refreshToken: return "Unauthorized"
        case .invalidAuth: return "Invalid Auth"
        }
    }
}

extension ErrorApp {
    func run(_ vc: UIViewController?) {
        guard let vc = vc else { return }
        var textAlert: String = ""
        switch self {
        case .invalidAuth, .refreshToken: return
        case .custom, .invalidJSON:
            textAlert = "Внимание!"
            textAlert += "\n\(self.text)"
        case .errorApp, .noInternet: textAlert = self.text
        }
        DispatchQueue.main.async { vc.displayAlert("", textAlert) }
    }
    func print(_ info: String? = nil) { Swift.print("\("👿".addPart(info, " ")) \(text)") }
    //
    static func setup(_ route: RouteAPI) -> ErrorApp {
        let statusCode = route.statusCode
        var text: String = ""

        if appService.isDebug {
            text = "\n====================\n"
            if let method = route.method {
                let path = method.description
                text += "\(path)"
                text += "\n"
            }
            text += "statusCode: \(statusCode)"
            text += "\n"
        }
        
        text += ErrorApp.setupTextError(json: route.dict)

        return .custom(text)
    }
    static func setupTextError(json: JSON) -> String {
        var text = ""
        if let msg = json.string("message") { text += msg }
        else if let msgList = json.stringList("message") { text += msgList.joined(separator: "\n") }
        
        if let errorDict = json.json("errors") {
            errorDict.forEach { (key, value) in
                var textD = "\(key):"
                (value as? [JSON])?.forEach { dict in
                    if let info = dict.string("message") { textD = textD.addPart(info, " ") }
                }
                text = text.addPart(textD, "\n")
            }
        }
        return text
    }
}
