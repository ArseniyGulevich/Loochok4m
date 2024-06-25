import UIKit

// MARK: - Register CellNib
extension UITableView {
    func registerCellNib(_ nibName: String) {
        let nibIdentifier = nibName.replacingOccurrences(of: "TableView", with: "")
        let cellNib = UINib(nibName: nibName, bundle: nil)
        self.register(cellNib, forCellReuseIdentifier: nibIdentifier)
    }
    func getCell<T: UITableViewCell>() -> T {
        let nibIdentifier = T.className.replacingOccurrences(of: "TableView", with: "")
        return self.dequeueReusableCell(withIdentifier: nibIdentifier) as! T
    }
    func getCell<T: UITableViewCell>(_ indexPath: IndexPath) -> T {
        let identifier = T.className.replacingOccurrences(of: "TableView", with: "")
        return self.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! T
    }
    //guard let cell = tableView.dequeueReusableCell(withIdentifier: "PopupMenuCell", for: indexPath) as? PopupMenuCell else { fatalError("Unabel to create cell") }
    func getCellByRow<T: UITableViewCell>(_ row: Int, _ section: Int = 0) -> T? {
        let indexPath = IndexPath(row: row, section: section)
        return self.cellForRow(at: indexPath) as? T
    }
}

// MARK: - Tap
extension UITableViewCell {
    func addTapGesture(_ tapView: UIView) {
        tapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        tapView.isUserInteractionEnabled = true
    }
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        //guard let tag = gestureRecognizer.view?.tag else { return }
    }
}

// MARK: - UITableView - с автовысотой для StackView
final class UITableView_contentSized: UITableView {
    override var contentSize:CGSize { didSet { invalidateIntrinsicContentSize() } }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
