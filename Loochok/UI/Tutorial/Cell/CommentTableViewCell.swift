import UIKit

class CommentTableViewCell: UITableViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nickLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    // MARK: - Variables
    var item: Comment!
    var didSelect: (()->Void)?
    var didTapComment: (()->Void)?
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addTapGesture(self.contentView)
        photoImageView.round_iv(23)
    }
    override func handleTap(_ gestureRecognizer: UITapGestureRecognizer) { didSelect?() }
    
    // MARK: - Setup UI
    func configureCell() {
        photoImageView.load_kf("https://avatar.iran.liara.run/public/boy")
        nickLabel.text = "@chiveskella"
        commentLabel.text = item.text
        dateLabel.text = item.date.toString(.date_ddMMyyyy)
    }
}
