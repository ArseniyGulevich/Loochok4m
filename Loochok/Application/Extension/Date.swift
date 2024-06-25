import Foundation

// MARK: Date format
extension Date {
    enum MaskDate: String {
        case api1  = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" //2024-06-11T11:34:45.134+03:00
        case date_ddMMyyyy = "dd.MM.yyyy" //13.02.2022
        case date_ddMM = "dd.MM" //13.02
        case time_HHmm  = "HH:mm" //00:01
        
        var mask: String { return self.rawValue }
    }
}

// MARK: ConvertType
extension Date {
    func dateFormatter(_ maskDate: MaskDate) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = maskDate.mask
        return dateFormatter
    }
    func toString(_ maskDate: MaskDate) -> String {
        return dateFormatter(maskDate).string(from: self)
    }
    // MARK: - formatted
    static func secondsToString(_ seconds: Double, _ allowedUnits: NSCalendar.Unit = [.minute, .second]) -> String {
        var formatter: DateComponentsFormatter {
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = allowedUnits//[.hour, .minute, .second]
            formatter.unitsStyle = .positional
            formatter.zeroFormattingBehavior = .pad
            return formatter
        }
        return formatter.string(from: seconds) ?? "00:00:00"
    }
    var timeTitle: String {
        if self.isToday { return "СЕГОДНЯ В \(self.toString(.time_HHmm))" }
        else if self.isYesterday { return "ВЧЕРА В \(self.toString(.time_HHmm))" }
        else if self.year == Date().year { return self.toString(.date_ddMM) }
        else { return self.toString(.date_ddMMyyyy) }
    }
}
extension String {
    func toDate(_ maskDate: Date.MaskDate) -> Date? {
        return Date().dateFormatter(maskDate).date(from: self)
    }
}

// MARK: - Компоненты, операции дат
extension Date {
    var year: Int { return Calendar.current.component(.year, from: self) }
    var isToday: Bool { return Calendar.current.isDateInToday(self) }
    var isYesterday: Bool { return Calendar.current.isDateInYesterday(self) }
}
