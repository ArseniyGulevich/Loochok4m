import Alamofire
import Photos

class API {  }

struct NetworkState {
    static var isConnected: Bool { return NetworkReachabilityManager()!.isReachable }
}

class MethodAPI {
    let host: String = "http://178.250.152.108:3000/api/v1/" //dev
    
    var method: HTTPMethod = .get
    var path: String = ""
    var parameters: Any?
    var encoding: ParameterEncoding { return (parameters is [JSON]) ? ArrayEncoding() : JSONEncoding.prettyPrinted }
    //JSONEncoding.prettyPrinted || URLEncoding.default
    var headers: HTTPHeaders = MethodAPI.header()
    var isRefreshToken: Bool = false
    
    // Extra
    var fullPath: String { return (path.contains("http") ? path : (host + path)).encodeUrl }
    var params: Parameters? {
        if let para  = parameters as? JSON { return para }
        else if let para = parameters as? [JSON] { return para.asParameters() }
        else if let para  = parameters as? String { return [para].asParameters() }
        else { return nil }
    }
    var description: String {
        var res = path.components(separatedBy: "?").first ?? path
        if appService.isDebug { res += " -> " + descriptionQuery }
        return res
    }
    var descriptionQuery: String {
        guard let query = path.components(separatedBy: "?").last else { return "" }
        return query.components(separatedBy: "&").first ?? query
    }
    
    // Helpers
    func printInfo(_ withHeader: Bool = true) {
        var res = "🛎️ infoMethodAPI:"
        res = res.addPart(fullPath, "\n")
        res = res.addPart("parameters: \(parameters ?? "")", "\n")
        res = res.addPart("method: \(method.rawValue)", "\n")
        if withHeader || appService.isDebug { res = res.addPart("headers:\n\(headers)", "\n") }
        
        print(res)
    }
    static func header(_ contentType: String = "application/json") -> HTTPHeaders {
        // application/json | multipart/form-data | application/x-www-form-urlencoded
        var dict: JSON = ["Accept": "application/json",
                          "Content-Type": contentType]
        if let token = appService.tokenAccess { dict["Authorization"] = "Bearer \(token)" }
        return dict.toHTTPHeaders()
    }
}

class RouteAPI {
    var method: MethodAPI?
    var statusCode: Int = 0
    var error: ErrorApp?
    var responseObject: Any?
    var dict: JSON = [:]
    var dictList: [JSON] = []
    var string: String = ""
    var stringList: [String] = []
    
    // MARK: - Extra
    var isSuccessful: Bool { return Array(200...299).contains(statusCode) }
    var isSuccess: Bool? {
        if let resultBool = dict.bool("success") { return resultBool }
        else { return nil }
    }
    
    // MARK: - Request
    func request(_ method: MethodAPI, closure: @escaping (RouteAPI)->()) {
        if appService.isDebug { method.printInfo() }
        self.method = method
        guard NetworkState.isConnected else { self.error = ErrorApp.noInternet; closure(self); return }
        makeRequestData(method) { (routeAPI) in closure(routeAPI) }
    }
    //
    func makeRequestData(_ method: MethodAPI, closure: @escaping (RouteAPI)->()) {
        AF.request(method.fullPath, method: method.method, parameters: method.params, encoding: method.encoding, headers: method.headers).response { (response) in
            self.statusCode = response.response?.statusCode ?? 0
            if appService.isDebug { print("• statusCode: \(self.statusCode)<-\(method.description)") }
            switch response.result {
            case .success(let responseObject):
                self.defineResponse(responseObject)
                closure(self)
            case .failure(let error):
                print(error.localizedDescription)
                self.error = ErrorApp.custom(error.localizedDescription)
                closure(self)
            }
        }
    }
}

// MARK: - HelpersFunctions
extension RouteAPI {
    private func defineResponse(_ responseObject: Any?) {
        guard let responseObject else { return }
        self.responseObject = responseObject
        // detect json
        if let data = responseObject as? Data {
            if let value = data.string { self.string = value }
            else if let value = data.stringList { self.stringList = value }
            else if let json = data.json {
                self.dict = json
                if appService.isDebug { printJSONString(json, "makeRequestData->JSON:") }
            } else if let jsonList = data.jsonList {
                self.dictList = jsonList
                if appService.isDebug { printJSONString(jsonList, "makeRequestData->JSONList:") }
            }
        }
        else if let dict = responseObject as? JSON { self.dict = dict }
        else if let dictList = responseObject as? [JSON] { self.dictList = dictList }
        // detect error
        detectError()
    }
    private func detectError() {
        if self.isSuccess == true { return }
        let textError = ErrorApp.setupTextError(json: dict)
        if self.statusCode == 401 { self.error = .refreshToken }
        else if !textError.isEmpty { self.error = ErrorApp.setup(self) }
        else if let isSuccess = self.isSuccess, !isSuccess { self.error = ErrorApp.setup(self) }
    }
}

// MARK: - Extensions for Dictionary
extension Dictionary where Key == String, Value == Any {
    func toHTTPHeaders() -> HTTPHeaders {
        HTTPHeaders(mapValues { String(describing: $0) })
    }
}
// MARK: - Extensions for string
extension String: ParameterEncoding {
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
}

// MARK: - extension for array
private let arrayParametersKey = "arrayParametersKey"

/// Extenstion that allows an array be sent as a request parameters
extension Array {
    /// Convert the receiver array to a `Parameters` object.
    func asParameters() -> Parameters {
        return [arrayParametersKey: self]
    }
}


/// Convert the parameters into a json array, and it is added as the request body.
/// The array must be sent as parameters using its `asParameters` method.
public struct ArrayEncoding: ParameterEncoding {
    
    /// The options for writing the parameters as JSON data.
    public let options: JSONSerialization.WritingOptions
    
    
    /// Creates a new instance of the encoding using the given options
    ///
    /// - parameter options: The options used to encode the json. Default is `[]`
    ///
    /// - returns: The new instance
    public init(options: JSONSerialization.WritingOptions = []) {
        self.options = options
    }
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()
        
        guard let parameters = parameters,
              let array = parameters[arrayParametersKey] else {
            return urlRequest
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: array, options: options)
            
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            
            urlRequest.httpBody = data
            
        } catch {
            throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
        }
        
        return urlRequest
    }
}
