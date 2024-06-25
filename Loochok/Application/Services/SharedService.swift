import UIKit

class SharedService {
    static func url(_ path: String?) -> URL? {
        guard let path = path, let url = URL(string: path), UIApplication.shared.canOpenURL(url)
        else { return nil }
        return url
    }
    static func open_www(_ path: String?) {
        guard let url = SharedService.url(path) else { return }
        let sharedApp = UIApplication.shared
        if #available(iOS 10, *) { sharedApp.open(url, options: [:], completionHandler: nil) }
        else { sharedApp.openURL(url) }
        return
    }
    static func open_www(_ url: URL?) {
        guard let url = url else { return }
        let sharedApp = UIApplication.shared
        if #available(iOS 10, *) { sharedApp.open(url, options: [:], completionHandler: nil) }
        else { sharedApp.openURL(url) }
        return
    }
    
    // MARK: Shared
    static func shared(_ sourceVC: UIViewController, _ textToShare: String?, _ image: UIImage?, _ path: String?) {
        var objsToShare: [Any] = []
        if let textToShare = textToShare { objsToShare.append(textToShare) }
        if let path = path, let url = URL(string: path) { objsToShare.append(url) }
        if let image = image { objsToShare.append(image) }
        
        guard !objsToShare.isEmpty else { return }
        let activityVC = UIActivityViewController(activityItems: objsToShare, applicationActivities: nil)
        sourceVC.present(activityVC, animated: true, completion: nil)
    }
}

// MARK: - SharedService in App
extension SharedService {
    /*
     https://vk.com/lchok
     https://t.me/loochok_media
     */
    static func open_wwwOrApp(_ path: String?, _ sourceVC: UIViewController) {
        guard let path = path, let url = URL(string: path) else { return }
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let host = components.host
        else { return }
        //print("open_wwwOrApp: \(path)\n host: \(host)\n path: \(components.path)")
        
        switch host {
        case "t.me": SharedService.open_www(path)
        case "vk.com": SharedService.open_www(path)
        default: SharedService.open_www(path)
        }
    }
}
