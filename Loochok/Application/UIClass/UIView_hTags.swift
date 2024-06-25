import UIKit

protocol ProtocolTag {
    var tagId: String { get }
    var tagName: String { get }
}

//@IBDesignable
class UIView_hTags: UIView {
    // MARK: Public Properties - UI
    @IBInspectable var titleText: String? = nil { didSet { setupFormData() } }
    @IBInspectable var hintText: String? = nil { didSet { setupFormData() } }
    @IBInspectable var dataText: String? = nil { didSet { setupFormData() } }
    @IBInspectable var isShowSepView: Bool = true { didSet { setupFormData() } }
    // MARK: Private UI Properties
    lazy var tagCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        //collectionView.setCollectionViewLayout(.leftAlignedLayout, animated: false)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.bounces = false
        //collectionView.alwaysBounceHorizontal = true
        //collectionView.isScrollEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.registerCell(CVCell_tag.self)
        return collectionView
    }()
    // MARK: Private Enums
    // MARK: Private Properties
    // MARK: Public Properties - Data
    var list: [ProtocolTag] = []
    var selectList: [ProtocolTag] = []
    var limit: Int = 1
    var isCanToggle: Bool = true
    // MARK: Public Properties
    // MARK: Public Action
    var didTap: ((ProtocolTag) -> Void)?
    
    // MARK: - Initializers
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayers()
    }
        
    // MARK: Private Methods
    private func setupLayers() {
    }
    private func setupViews() {
        addSubviews()
        makeConstraints()
        //
        //setupCollectionView()
        setupFormData()
    }
}

// MARK: - addSubviews+makeConstraints
extension UIView_hTags {
    private func addSubviews() {
        self.addSubview(tagCV)
    }
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            // tagCV
            tagCV.topAnchor.constraint(equalTo: self.topAnchor),
            tagCV.leftAnchor.constraint(equalTo: self.leftAnchor),
            tagCV.rightAnchor.constraint(equalTo: self.rightAnchor),
            tagCV.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

// MARK: - Private Helpers
extension UIView_hTags {
    private func setupFormData() {
        
        //tagCV.reloadData()
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension UIView_hTags: UICollectionViewDataSource, UICollectionViewDelegate {
//    private func setupCollectionView() {
////        tagCV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
////        tagCV.dataSource = self
////        tagCV.delegate = self
////        tagCV.bounces = false
////        tagCV.registerCell(CVCell_tag.self)
////        setupCVLayout_tagCV()
//    }
//    private func setupCVLayout_tagCV() {
////        let cellW = ((Screen.width - (2*4) - (2*2)) / 3).rounded(.towardZero)
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
////        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
////        layout.itemSize = CGSize(width: cellW, height: cellW)
////        layout.minimumInteritemSpacing = 2
////        layout.minimumLineSpacing = 2
//        layout.scrollDirection = .horizontal
//        tagCV.collectionViewLayout = layout
//    }
    // UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        let item = list[row]
        let isSelect = selectList.map(\.tagId).contains(item.tagId)
        let cell: CVCell_tag = collectionView.getCell(indexPath)
        cell.item = item
        cell.isSelect = isSelect
        cell.configureCell()
        cell.didSelect = {
            if isSelect && !self.isCanToggle { return }
            
            switch self.limit {
            case 1:
                self.selectList.removeAll()
                switch isSelect {
                case false: self.selectList.append(item)
                case true: ()
                }
                self.tagCV.reloadData()
            default: ()
            }
            self.didTap?(item)
        }
//        cell.tapDeleteHandler = { [weak self] in
//            self?.tags.remove(at: indexPath.row)
//            self?.tagsCollectionView.reloadData()
//        }
        return cell
    }
}
extension UIView_hTags: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = list[indexPath.row]
        let cellW: CGFloat = 16+item.tagName.widthOfString(.sfProDisplayM(13))+16
        let cellH: CGFloat = 32
        return CGSize(width: cellW.rounded(), height: cellH)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return sectionInsets
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    } //интервал между ячейками в строке
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    } //интервал между последовательными строками или столбцами раздела
}

// MARK: - Public Functions
extension UIView_hTags {
}

class CVCell_tag: UICollectionViewCell {
    // MARK: UI Properties
    private(set) lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        //stackView.preservesSuperviewLayoutMargins = true
        //stackView.isLayoutMarginsRelativeArrangement = true
        //stackView.layoutMargins = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(nameLabel)
        return stackView
    }()
    private(set) lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.sfProDisplayM(13)
        label.textColor = UIColor("FFFFFF")
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    // MARK: Public Properties
    var item: ProtocolTag!
    var isSelect: Bool = false
    // MARK: - CallBack
    var didSelect: HandlerVoid?
    
    // MARK: - Initializers
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayers()
    }
}

// MARK: Private Methods
extension CVCell_tag {
    // MARK: Private Methods
    private func setupLayers() {
    }
    private func setupViews() {
        self.addViews()
        self.addTapGesture(self.contentView)
        contentView.round(16)
    }
    override func handleTap(_ gestureRecognizer: UITapGestureRecognizer) { didSelect?() }
    // MARK: - SetupCell
    func configureCell() {
        contentView.backgroundColor = isSelect ? UIColor("000000") : UIColor("EDEDEF")
        nameLabel.text = item.tagName
        nameLabel.textColor = isSelect ? UIColor("FFFFFF") : UIColor("828283")
    }
}

// MARK: - addViews
extension CVCell_tag {
    // addViews
    private func addViews() {
        self.contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            // stackView
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12),
            stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}
