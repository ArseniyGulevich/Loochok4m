import UIKit

class IntroCollectionViewCell: UICollectionViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var photoTImageView: UIImageView!
    @IBOutlet weak var photoMImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    // MARK: - Variables
    var item: IntroData!
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Setup UI
    func configureCell() {
        photoTImageView.image = UIImage(named: item.photoNameTop)
        photoMImageView.image = UIImage(named: item.photoNameMain)
        titleLabel.text = item.title
    }
}
