import UIKit

class TutorialTableViewCell: UITableViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var tagsView: UIView_hTags!
    // MARK: - IBAction
    @IBAction func likeButtonPressed(_ sender: UIButton) { self.didTapLike?() }
    // MARK: - Variables
    var item: Post!
    var didSelect: (()->Void)?
    var didTapLike: (()->Void)?
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addTapGesture(self.contentView)
        bgView.round(28)
        bgView.layer.applyShadow(blur: 6, x: 0, y: 2, "000000", 0.08)
        photoImageView.round(20)
    }
    override func handleTap(_ gestureRecognizer: UITapGestureRecognizer) { didSelect?() }
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.kf.cancelDownloadTask()
        photoImageView.image = nil
    }
    
    // MARK: - SetupCell
    func configureCell() {
        photoImageView.load_kf(item.pathPhoto)
        nameLabel.text = item.title
        likeButton.setImage(UIImage(named: "like\(item.isLike ? "1" : "0")"), for: .normal)
        setupUIView_tags()
    }
}

// MARK: - UIView_tags
extension TutorialTableViewCell {
    private func setupUIView_tags() {
        let tagFullList: [Tag] = Tag.tagList
        tagsView.isHidden = tagFullList.isEmpty
        
        tagsView.list = tagFullList
        tagsView.selectList = tagFullList
        tagsView.limit = 0
        tagsView.tagCV.reloadData()
        tagsView.didTap = { (_) in () }
    }
}
