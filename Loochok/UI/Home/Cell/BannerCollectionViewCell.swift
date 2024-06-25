import UIKit

class BannerCollectionViewCell: UICollectionViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel_padding!
    // MARK: - Variables
    var item: Banner!
    var didSelect: (()->Void)?
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addTapGesture(self.contentView)
        photoImageView.decorateView_roundBorder(20, UIColor("000000"), 4)
        photoImageView.round_iv(20)
        //nameLabel.padding(8, 8, 8, 8)
        nameLabel.roundCorners(20, [.layerMinXMaxYCorner])
    }
    override func handleTap(_ gestureRecognizer: UITapGestureRecognizer) { didSelect?() }
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.kf.cancelDownloadTask()
        photoImageView.image = nil
    }
    
    // MARK: - Setup UI
    func configureCell() {
        photoImageView.image = UIImage(named: item.pathPhoto)
        nameLabel.text = item.name.uppercased()
    }
}
