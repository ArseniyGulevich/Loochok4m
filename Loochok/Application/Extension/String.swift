import UIKit

// MARK: - Format
extension String {
    func clearSpace() -> String { return self.replacingOccurrences(of: " ", with: "") }
    func addPart(_ part: String?, _ separator: String) -> String {
        guard let part = part, !part.isEmpty else { return self }
        return self.isEmpty ? part : "\(self)\(separator)\(part)"
    }
    func copyToClipBoard() { UIPasteboard.general.string = self }
}

// MARK: - Decoder url
extension String {
    var encodeUrl: String {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    var decodeUrl: String { return self.removingPercentEncoding! }
    var url: URL? {
        guard let url = URL(string: self) else { return nil }
        return url
    }
}

// MARK: - Format
extension String {
    var formatSpaceToUnderscore: String { replacingOccurrences(of: " ", with: "_") }
}

// MARK: - ToNumber
extension String {
    var intValue: Int? { return Int(self) }
    var doubleValue: Double? { return Double(self.clearSpace()) }
    var decimalValue: Decimal? {
        let text = self.replacingOccurrences(of: " ", with: "").clearSpace()
        if let value = Decimal(string: text) { return value }
        else if let value = Decimal(string: text.replacingOccurrences(of: ",", with: ".")) { return value }
        else if let value = Decimal(string: text.replacingOccurrences(of: ".", with: ",")) { return value }
        else { return nil }
    }
}

// MARK: Size/width/height Text by font
extension String {
    func widthOfString(_ font: UIFont) -> CGFloat { return self.sizeOfString(font).width }
    func heightOfString(_ font: UIFont) -> CGFloat { return self.sizeOfString(font).height }

    func sizeOfString(_ font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
    func size(for font: UIFont) -> CGSize {
        let attributes = [NSAttributedString.Key.font: font]
        let string = NSAttributedString(string: self, attributes: attributes)
        return string.size()
    }
}
