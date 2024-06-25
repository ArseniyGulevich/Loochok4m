import UIKit

class MenuAddViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var const_contentView_b: NSLayoutConstraint!
    @IBOutlet var menuViewList: [UIView]!
    // MARK: - IBAction
    // MARK: - Variables
    var constrB: CGFloat = 16
    var didSelect: ((Int)->Void)?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showAnimate()
        setupTapGestureRecognizer()
        setupUI()
        setupFormData()
    }
    
    // MARK: - setupFormData
    private func setupFormData() {
    }
    
    // MARK: - Actions

    // MARK: - SetupUI
    private func setupUI() {
        contentView.round(12)
        const_contentView_b.constant = constrB
    }

    // MARK: - Navigation
}

// MARK: - Animations
extension MenuAddViewController {
    func showAnimate() {
        contentView.transform = .identity
        contentView.transform = CGAffineTransform(a: 0, b: 0, c: 1, d: 0, tx: 0, ty: 0)
        bgView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.contentView.transform = .identity
            self.bgView.alpha = 1
        }
    }
    func removeAnimate(_ duration: TimeInterval = 0.15) {
        UIView.animate(withDuration: duration, animations: {
            self.contentView.transform = CGAffineTransform(a: 0, b: 0, c: 1, d: 0, tx: 0, ty: 0)
            self.bgView.alpha = 0
        }) { (_) in self.removePopUp() }
    }
}

// MARK: - UITapGestureRecognizer
extension MenuAddViewController {
    private func setupTapGestureRecognizer() {
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedOn_tapView)))
        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedOn_contentView)))
        menuViewList.forEach { $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap_menuBookView))) }
    }
    @objc private func tappedOn_tapView(_ gestureRecognizer: UITapGestureRecognizer) {
        self.didSelect?(0)
        removeAnimate()
    }
    @objc private func tappedOn_contentView(_ gestureRecognizer: UITapGestureRecognizer) {}
    @objc private func tap_menuBookView(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let tag = gestureRecognizer.view?.tag else { return }
        self.didSelect?(tag)
        removeAnimate()
    }
}
