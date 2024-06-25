import UIKit

// MARK: - Compress
extension UIImage {
    func compressToMb(_ expectedSizeInMb: Double?) -> Data? {
        guard let expectedSizeInMb else { return self.jpegData(compressionQuality: 1) }
        let sizeInBytes = Int(expectedSizeInMb * 1024 * 1024)
        if let data = self.jpegData(compressionQuality: 1),
           data.count < sizeInBytes
        { return data }

        var needCompress: Bool = true
        var imgData: Data?
        var compressingValue: CGFloat = 1.0
        while (needCompress && compressingValue > 0.0) {
            if let data: Data = self.jpegData(compressionQuality: compressingValue) {
                if data.count < sizeInBytes {
                    needCompress = false
                    imgData = data
                } else { compressingValue -= 0.1 }
            }
        }

        guard let data = imgData, (data.count < sizeInBytes) else { return nil }
        return data
    }
}

// MARK: - reSize
extension UIImage {
    func cropToSquare(_ size: CGSize? = nil) -> UIImage {
        let minWH: CGFloat = min(self.size.width, self.size.height)
        let cgimage = self.cgImage!
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(size?.width ?? minWH)
        var cgheight: CGFloat = CGFloat(size?.height ?? minWH)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = cgimage.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
        
        return image
    }
    //
    func cropToSize(_ size: CGSize) -> UIImage {
        guard size.width != 0 && size.height != 0 else { return self }
        let cgimage = self.cgImage!
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        let cropAspect: CGFloat = size.width / size.height
        var cgwidth: CGFloat = CGFloat(size.width)
        var cgheight: CGFloat = CGFloat(size.height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height * cropAspect
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width / cropAspect
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        let imageRef: CGImage = cgimage.cropping(to: rect)!
        let image: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
        
        return image
    }
}
