import Kingfisher

class KingfisherHelper {
    enum TypeProcessor {
        case downsampling
        case cropping
        case resizing_Cropping
    }
    
    static func clearCache() {
        let cache = ImageCache.default
        // Remove all.
        cache.clearMemoryCache()
        cache.clearDiskCache { print("Done") }

        // Remove only expired.
        cache.cleanExpiredMemoryCache()
        cache.cleanExpiredDiskCache { print("Done") }
    }
    static func cachedImage(_ image: UIImage?, _ path: String?) {
        guard let image = image, let path = path else { return }

        let cache = ImageCache.default
        cache.store(image, forKey: path)
        print("Cached image with path: \(path)")
    }
}

// MARK: - prepareCache
extension KingfisherHelper {
    static func prepareCache(_ list: [String]) {
        let cache = ImageCache.default
        list.forEach { (path) in
            let cacheKey = path
            guard !cache.isCached(forKey: cacheKey) else { return }
            getImage(path) { (image) in
                guard let image else { return }
                cache.store(image, forKey: cacheKey)
                print("🤌 isCached \(cacheKey)")
            }
        }
    }
}

// MARK: - Loadersfunctions
extension KingfisherHelper {
    static func getImage(_ path: String?, closure: @escaping (_ image: UIImage?) -> Void) {
        guard let path = path, let url = URL(string: path) else { closure(nil); return }

        let downloader = ImageDownloader.default
        downloader.downloadImage(with: url) { result in
            switch result {
            case .failure(let error): closure(nil)
                if appService.isDebug { print("👿 getImage error: \(error.localizedDescription)") }
            case .success(let value): closure(value.image)
            }
        }
    }
}

extension UIImageView {
    func load_kf(_ path: String?, imageDef: UIImage? = nil,
                 typeProcessor: KingfisherHelper.TypeProcessor = .resizing_Cropping,
                 mode: Kingfisher.ContentMode = .aspectFill,
                 closure: ((_ img: UIImage?) -> Void)? = nil) {
        //print(path)
        guard let path = path, let url = URL(string: path)
        //else { self.image = nil; return }
        else { DispatchQueue.main.async { self.image = imageDef }; return }
        
        let resource = KF.ImageResource(downloadURL: url)//, cacheKey: "\(item.id)"
        var ivSize = self.bounds.size
        if ivSize.width == 0 || ivSize.height == 0 {
            ivSize = CGSize(width: (ivSize.width == 0) ? 300 : ivSize.width, height: (ivSize.height == 0) ? 200 : ivSize.height)
            //print(ivSize)
        }
        //print("loadIV ivSize: \(ivSize)")
        
        let processor: ImageProcessor
        switch typeProcessor {
        case .downsampling:
            processor = DownsamplingImageProcessor(size: ivSize)
        case .cropping:
            processor = CroppingImageProcessor(size: ivSize)
        case .resizing_Cropping:
            processor = ResizingImageProcessor(referenceSize: ivSize, mode: mode) |> CroppingImageProcessor(size: ivSize)
        }
        //
        
        self.kf.indicatorType = .activity
        self.kf.setImage(
            with: resource,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.5)),
                .cacheOriginalImage
            ]) {
            result in
            switch result {
            case .failure(let error): self.image = imageDef; closure?(nil)
                if appService.isDebug { print("👿 load_kf: \(error.localizedDescription)") }
            case .success(let value): closure?(value.image)
                //print("\(value.cacheType) = \(resource.cacheKey)")
            }
        }
    }
}

// MARK: - DispatchQueue
extension UIImageView {
    func setImageDQ(_ image: UIImage?) { DispatchQueue.main.async { self.image = image } }
    func setImage_byPath(_ path: String?) {
        guard let path = path, let url = URL(string: path)
        else { self.setImageDQ(nil); return }
        
        self.kf.indicatorType = .activity
        self.kf.setImage(with: url)
    }
}
