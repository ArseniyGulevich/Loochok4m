import UIKit
import PhotosUI

class ImagePicker: NSObject {
    // Enums
    enum SelectionMedia {
        case all
        case image
        case video
        
        var mediaTypes: [String] {
            switch self {
            case .all: return ["public.image", "public.movie"]
            case .image: return ["public.image"]
            case .video: return ["public.movie"]
            }
        }
    }
    // MARK: Private Properties
    private var selectionMedia: SelectionMedia = .image
    private var selectionLimit: Int? = 1
    private let imagePickerVC: UIImagePickerController = UIImagePickerController()
    private weak var sourceVC: UIViewController?
    
    // MARK: Public Properties
    //var didSelect: ((UIImage)->Void)?
    var didSelectMediaDataList: (([MediaData])->Void)?
    
    // MARK: - Initializers
    public init(sourceVC: UIViewController, selectionMedia: SelectionMedia = .image, selectionLimit: Int? = 1) {
        super.init()
        
        self.sourceVC = sourceVC
        self.selectionMedia = selectionMedia
        self.selectionLimit = selectionLimit
        
        self.imagePickerVC.delegate = self
        self.imagePickerVC.allowsEditing = false
    }
}

// MARK: - MenuActions
extension ImagePicker {
    public func goToMenuActionVC() {
        guard let topVC = UIApplication.getTopVC() else { return }
        
        let cameraAction = UIAlertAction(title: "Сделать снимок", style: .default) { (_) in
            self.selectPhotoPressed(.camera)
        }
        let galleryAction = UIAlertAction(title: "Выбрать из галереи", style: .default) { (_) in
            if #available(iOS 14, *) { self.pickPhotos() }
            else { self.selectPhotoPressed(.photoLibrary) }
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        topVC.showAlert(withTitle: nil, message: nil, style: .actionSheet) { alertController in
            
            alertController.addAction(cameraAction)
            alertController.addAction(galleryAction)
            alertController.addAction(cancelAction)
        }
    }
    public func makePhoto() {
        selectPhotoPressed(.camera)
    }
    public func selectPhoto() {
        if #available(iOS 14, *) { self.pickPhotos() }
        else {
            self.imagePickerVC.mediaTypes = selectionMedia.mediaTypes
            self.selectPhotoPressed(.photoLibrary)
        }
    }
}

// MARK: - PrivateFunctions
extension ImagePicker {
}

// MARK: - PickerPhotos iOS < 14
// MARK: - UIImagePickerControllerDelegate
extension ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func selectPhotoPressed(_ sourceType: UIImagePickerController.SourceType = .photoLibrary) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else { return }
        
        imagePickerVC.sourceType = sourceType
        sourceVC?.present(imagePickerVC, animated: true)
    }
    // UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePickerVC.dismiss(animated: false, completion: nil)
        
        if let image = info[.originalImage] as? UIImage {
            let url = info[UIImagePickerController.InfoKey.imageURL] as? URL
            let name = url?.deletingPathExtension().lastPathComponent ?? "image"
            //print("name photo: \(name)")
            let mData = MediaData(image: image, name: name)
            DispatchQueue.main.async { self.didSelectMediaDataList?([mData]) }
        }
    }
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePickerVC.dismiss(animated: false, completion: nil)
    }
}

// MARK: - PickerPhotos iOS >= 14
@available(iOS 14.0, *)
extension ImagePicker: PHPickerViewControllerDelegate {
    private func pickPhotos() {
        var config = PHPickerConfiguration()
        config.selectionLimit = self.selectionLimit ?? 0
        switch self.selectionMedia {
        case .all: config.filter = .any(of: [.images, .videos])
        case .image: config.filter = .any(of: [.images])
        case .video: config.filter = .any(of: [.videos])
        }

        let pickerViewController = PHPickerViewController(configuration: config)
        pickerViewController.delegate = self
        pickerViewController.isEditing = false
        sourceVC?.present(pickerViewController, animated: true, completion: nil)
    }
    // MARK: PHPickerViewControllerDelegate
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        //picker.dismiss(animated: true)
        var mdList = [MediaData]()
        let dispatchGroup = DispatchGroup()
        
        let imageProviderList = results.map({ $0.itemProvider })
                                      .filter { $0.canLoadObject(ofClass: UIImage.self) }
//        let videoProviderList = results.map({ $0.itemProvider })
//                                      .filter { $0.hasItemConformingToTypeIdentifier(UTType.movie.identifier) }
        // image
        imageProviderList.forEach { (itemProvider) in
            let name = itemProvider.suggestedName
            
            dispatchGroup.enter()
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                if let image = image as? UIImage { mdList.append(MediaData(image: image, name: name)) }
                dispatchGroup.leave()
            }
        }
        
        // total
        dispatchGroup.notify(queue: .main) {
            DispatchQueue.main.async {
                self.didSelectMediaDataList?(mdList)
                picker.dismiss(animated: true)
            }
        }
    }
}
