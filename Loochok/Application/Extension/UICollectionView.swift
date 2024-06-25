import UIKit

extension UICollectionView {
    func registerCell(_ cellClass: UICollectionViewCell.Type) {
        let identifier = cellClass.className.replacingOccurrences(of: "CollectionView", with: "")
        self.register(cellClass.self, forCellWithReuseIdentifier: identifier)
    }
    func registerCellNib(_ nibName: String) {
        let nibIdentifier = nibName.replacingOccurrences(of: "CollectionView", with: "")
        let cellNib = UINib(nibName: nibName, bundle: nil)
        self.register(cellNib, forCellWithReuseIdentifier: nibIdentifier)
    }
    func getCell<T: UICollectionViewCell>(_ indexPath: IndexPath) -> T {
        let nibIdentifier = T.className.replacingOccurrences(of: "CollectionView", with: "")
        return self.dequeueReusableCell(withReuseIdentifier: nibIdentifier, for: indexPath) as! T
    }
    func getCellByRow<T: UICollectionViewCell>(_ row: Int, _ section: Int = 0) -> T? {
        let indexPath = IndexPath(row: row, section: section)
        return self.cellForItem(at: indexPath) as? T
    }
}

// MARK: - Tap
extension UICollectionViewCell {
    func addTapGesture(_ tapView: UIView) {
        tapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        tapView.isUserInteractionEnabled = true
    }
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        //guard let tag = gestureRecognizer.view?.tag else { return }
    }
}

// MARK: - UICollectionView - с автовысотой для StackView
final class UICollectionView_сontentSized: UICollectionView {
    override var contentSize: CGSize { didSet { invalidateIntrinsicContentSize() } }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

extension UICollectionView {
    func reloadDataWithAutoSizingCellWorkAround() {
        self.reloadData()
        self.setNeedsLayout()
        self.layoutIfNeeded()
        delay(0.1) { self.reloadData() }
    }
}

// MARK: - centerIndexPath
extension UICollectionView {
    var centerIndexPath: IndexPath? {
        let centerPoint = CGPoint(x: self.contentOffset.x + (self.frame.width / 2), y: (self.frame.height / 2))
        return self.indexPathForItem(at: centerPoint)
    }
    var centerRow: Int? { return centerIndexPath?.row }
}

// MARK: - Scroll
extension UICollectionView {
    func scrollPageToRow(_ row: Int, _ animated: Bool = true) {
        let indexPath = IndexPath(row: row, section: 0)
        guard row < self.numberOfItems(inSection: 0) else { return }
        
        self.isPagingEnabled = false
        self.scrollToItem(at: indexPath, at: [.centeredVertically, .centeredHorizontally], animated: animated)
        self.isPagingEnabled = true
    }
    // MARK: - Scroll
    func scrollToRow(_ row: Int, _ section: Int = 0, _ animated: Bool = true) {
        guard self.numberOfSections >= (section+1),
              self.numberOfItems(inSection: section) >= (row+1)
        else { return }
        let scrollPosition: UICollectionView.ScrollPosition = (row == 0) ? .left : .right
        self.scrollToItem(at: IndexPath(row: row, section: section), at: scrollPosition, animated: animated)
    }
    //
    func scrollToLeft(_ animated: Bool = true) {
        let leftOffset = CGPoint(x: -contentInset.left, y: 0)
        setContentOffset(leftOffset, animated: animated)
    }
    func scrollToRight(_ animated: Bool = true) {
        self.scrollToRow(self.numberOfItems(inSection: 0)-1, 0, animated)
    }
}
