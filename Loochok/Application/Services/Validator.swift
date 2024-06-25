import Foundation

struct Validator {
    public enum TypeData {
        case email
        case psw
        case simple
        
        var errorEmpty: String {
            switch self {
            case .email: return "Введите email"
                //Введите адрес электронной почты
            case .psw: return "Введите пароль"
            case .simple: return ""
            }
        }
        var errorWrong: String {
            switch self {
            case .email: return "Введите email в формате name@mail.com"
                //"Неверный адрес электронной почты" / Неправильный адрес почты
            case .psw: return "Введите пароль"
            case .simple: return ""
            }
        }
    }
}

// MARK: Variables
extension Validator {
    func data_error(_ typeData: TypeData, _ text: String?) -> String? {
        switch typeData {
        case .email: return email_error(text)
        case .psw: return psw_error(text)
        case .simple: return (text ?? "").isEmpty ? "Заполните поле" : nil
        }
    }
    
    // MARK: email
    func email_clear(_ text: String?) -> String { return text?.clearSpace().lowercased() ?? "" }
    func email_isValid(_ text: String?) -> Bool {
        let email = email_clear(text)
        guard !email.isEmpty else { return false }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9._-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    func email_error(_ text: String?) -> String? {
        let email = email_clear(text)
        guard !email.isEmpty else { return TypeData.email.errorEmpty }
        guard !email_isValid(email) else { return nil }
        return TypeData.email.errorWrong
    }
    // MARK: password
    func psw_clear(_ text: String?) -> String { return text?.clearSpace() ?? "" }
    func psw_isValid(_ text: String?) -> Bool { return psw_error(text) == nil }
    func psw_error(_ text: String?) -> String? {
        let pswMin = 4
        let psw = psw_clear(text)
        guard !psw.isEmpty else { return TypeData.psw.errorEmpty }
        if psw.count < pswMin { return "Пароль должен содержать не менее \(pswMin) символов" }
        else { return nil }
        //return TypeData.email.errorWrong
    }
}
