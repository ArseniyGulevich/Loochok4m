import UIKit

class MediaData {
    var type: TypeMedia
    var path: String?

    // Extra
    var name: String?
    var image: UIImage?
    var data: Data?
    
    // MARK: - Initializers
    init(image: UIImage, name: String? = nil) {
        self.type = .image
        self.image = image
        self.name = name
        self.data = image.compressToMb(2)
    }
}

// MARK: - Extra
extension MediaData {
    // for upload
    var fileName: String {
        if let name = self.name, !name.isEmpty { return name }
        else { return "\(UUID().uuidString)" }
    }
    var mimeType: String {
        switch type {
        case .image: return "image/jpeg"
        case .video: return "video/video"
        case .file: return "file/file"
        }
    }
}

// MARK: - Enum TypeMedia
public enum TypeMedia: String {
    case image
    case video
    case file
    
    var id: String { return self.rawValue }
}
