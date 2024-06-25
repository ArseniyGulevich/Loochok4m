import UIKit

class UIView_popUpMenu: UIView {
    // MARK: Public Properties - UI
    // MARK: Private Properties = UI
    private(set) lazy var menuBackView: UIView = {
        let view = UIView(frame: CGRect(origin: .zero,
                                        size: CGSize(width: UIScreen.main.bounds.width,
                                                     height: UIScreen.main.bounds.height)))
        view.backgroundColor = UIColor("000000", 0.4)
        view.alpha = 0
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(touchOutside))
        view.addGestureRecognizer(tap)
        return view
    }()
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        //tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: UIScreen.saB, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(PopupMenuCell.self, forCellReuseIdentifier: "PopupMenuCell")
        return tableView
    }()
    // MARK: Private constants
    let mainWindow = UIApplication.shared.keyWindow!
    let screenW = UIScreen.main.bounds.size.width
    let screenH = UIScreen.main.bounds.size.height
    // MARK: Private Properties
    private var relyRect: CGRect = CGRect.zero
    var point: CGPoint = CGPoint.zero
    private var offset: CGFloat = 0.0
    private var itemH: CGFloat = 48 {
        didSet {
            tableView.rowHeight = itemH
            updateUI()
        }
    }
    private var itemW: CGFloat = 0 { didSet { updateUI() } }
    private var priorityDirection: PopupMenuPriorityDirection = .top { didSet{ } } // updateUI() } }
    private var borderW: CGFloat = 0
    private var arrowW: CGFloat = 15
    private var arrowH: CGFloat = 10
    private var arrowPosition: CGFloat = 0
    private var arrowDirection: PopupMenuArrowDirection = .top { didSet{ } } // updateUI() } }
    private var minSpace: CGFloat = 10.0
    private var isChangeDirection : Bool = false
    override open var frame: CGRect {
        didSet {
            switch arrowDirection {
            case .top:
                tableView.frame = CGRect.init(x: borderW, y: borderW + arrowH, width: frame.size.width - borderW * 2, height: frame.size.height - arrowH)
            case .bottom:
                tableView.frame = CGRect.init(x: borderW, y: borderW , width: frame.size.width - borderW * 2, height: frame.size.height - arrowH)
            case .left:
                tableView.frame = CGRect.init(x: borderW + arrowH, y: borderW, width: frame.size.width - borderW * 2 - arrowH, height: frame.size.height)
            case .right:
                tableView.frame = CGRect.init(x: borderW, y: borderW , width: frame.size.width - borderW * 2 - arrowH, height: frame.size.height)
            case .none:
                tableView.frame = CGRect.init(x: borderW, y: borderW , width: frame.size.width - borderW * 2 , height: frame.size.height)
            }
        }
    }
    // MARK: Private Properties - Data
    var list: [PopUpMenuItem] = []
    // MARK: Public Properties - Data
    // MARK: Public Properties
    // MARK: Public Action
    typealias Block_didSelect = (_ item: PopUpMenuItem, _ row: Int)->Void
    var didSelect: Block_didSelect?
    //var didSelect: ((_ item: PopUpMenuItem, _ row: Int)->Void)?
    
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
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let bezierPath = PopupMenuPath.bezierPathWithRect(myRect: rect, rectCorner: UIRectCorner.allCorners, cornerRadius: 5, borderW: borderW, borderColor: .clear, backgroundColor: UIColor("E1E8ED"), arrowW: arrowW, arrowH: arrowH, myArrowPosition: arrowPosition, arrowDirection: arrowDirection)
        bezierPath.fill()
        bezierPath.stroke()
    }
}

// MARK: Private Methods
extension UIView_popUpMenu {
    // MARK: Private Methods
    private func setupLayers() {
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
    }
    private func setupViews() {
        alpha = 0
        backgroundColor = .clear
        //
        addSubview(tableView)
    }
    //
    private func show() {
        mainWindow.addSubview(menuBackView)
        mainWindow.addSubview(self)
        
        layer.setAffineTransform(CGAffineTransform.init(scaleX: 0.1, y: 0.1))
        UIView.animate(withDuration: 0.25) {
            self.layer.setAffineTransform(CGAffineTransform.init(scaleX: 1.0, y: 1.0))
            self.alpha = 1
            self.menuBackView.alpha = 1
        }
    }
}

// MARK: - Draw
extension UIView_popUpMenu {
    func updateUI() {
        let maxVisibleCount: Int = 8 //QW-sonra= поменять на расчетное
        var height: CGFloat = 0
        if list.count > maxVisibleCount {
            height = itemH * CGFloat(maxVisibleCount) + borderW*2
            tableView.bounces = true
        } else {
            height = itemH * CGFloat(list.count) + borderW*2
            tableView.bounces = false
        }
        isChangeDirection = false
        
        switch priorityDirection {
        case .top:
            if point.y + height + arrowH > screenH - minSpace {
                arrowDirection = PopupMenuArrowDirection.bottom
                isChangeDirection = true
            }else{
                arrowDirection = PopupMenuArrowDirection.top
                isChangeDirection = false
            }
        case .bottom:
            if point.y - height - arrowH < minSpace {
                arrowDirection = PopupMenuArrowDirection.top
                isChangeDirection = true
            }else{
                arrowDirection = PopupMenuArrowDirection.bottom
                isChangeDirection = false
            }
        case .left:
            if point.x + itemW + arrowH > screenW - minSpace {
                arrowDirection = PopupMenuArrowDirection.right
                isChangeDirection = true
            }else{
                arrowDirection = PopupMenuArrowDirection.left
                isChangeDirection = false
            }
        case .right:
            if point.x - itemW - arrowH < minSpace {
                arrowDirection = PopupMenuArrowDirection.left
                isChangeDirection = true
            }else{
                arrowDirection = PopupMenuArrowDirection.right
                isChangeDirection = false
            }
        default:
            if point.y + height + arrowH > screenH - minSpace {
                isChangeDirection = true
            }else{
                isChangeDirection = false
            }
            arrowDirection = PopupMenuArrowDirection.none
        }
        
        
        setArrowPosition()
        setRelyRect()
        
        switch arrowDirection {
        case .top:
            let y =  point.y
            if arrowPosition > itemW / 2 {
                frame = CGRect.init(x: screenW - minSpace - itemW, y:y , width: itemW, height: height + arrowH)
            }else if arrowPosition < itemW / 2 {
                frame = CGRect.init(x: minSpace, y:y , width: itemW, height: height + arrowH)
            }else{
                frame = CGRect.init(x: point.x - itemW / 2, y:y , width: itemW, height: height + arrowH)
            }
        case .bottom:
            let y = point.y - arrowH - height
            if arrowPosition > itemW / 2 {
                frame = CGRect.init(x: screenW - minSpace - itemW, y:y , width: itemW, height: height + arrowH)
            }else if arrowPosition < itemW / 2 {
                frame = CGRect.init(x: minSpace, y:y , width: itemW, height: height + arrowH)
            }else{
                frame = CGRect.init(x: point.x - itemW / 2, y:y , width: itemW, height: height + arrowH)
            }
        case .left:
            let x = point.x
            if arrowPosition < itemH / 2 {
                frame = CGRect.init(x: x , y:point.y - arrowPosition, width: itemW + arrowH, height: height )
            }else if arrowPosition > itemH / 2 {
                frame = CGRect.init(x: x, y:point.y - arrowPosition, width: itemW + arrowH, height: height)
            }else{
                frame = CGRect.init(x: x, y:point.y - arrowPosition, width: itemW + arrowH, height: height)
            }
        case .right:
            let x = isChangeDirection ? point.x - itemW - arrowH - 2*borderW : point.x - itemW - arrowH - 2*borderW
            if arrowPosition < itemH / 2 {
                frame = CGRect.init(x: x , y:point.y - arrowPosition, width: itemW + arrowH, height: height )
            }else if arrowPosition > itemH / 2 {
                frame = CGRect.init(x: x-itemW/2, y:point.y - arrowPosition, width: itemW + arrowH, height: height)
            }else{
                frame = CGRect.init(x: x, y:point.y - arrowPosition, width: itemW + arrowH, height: height)
            }
        case .none:
            let y = isChangeDirection ? point.y - arrowH - height : point.y + arrowH
            if arrowPosition > itemW / 2 {
                frame = CGRect.init(x: screenW - minSpace - itemW, y:y , width: itemW, height: height )
            }else if arrowPosition < itemW / 2 {
                frame = CGRect.init(x: minSpace, y:y , width: itemW, height: height)
            }else{
                frame = CGRect.init(x: point.x - itemW / 2, y:y , width: itemW, height: height)
            }
        }
        
        setAnchorPoint()
        setOffset()
        tableView.reloadData()
        setNeedsDisplay()
    }
    
    func setArrowPosition() {
        if priorityDirection == .none {
            return
        }
        if arrowDirection == .top || arrowDirection == .bottom {
            if point.x + itemW / 2 > screenW - minSpace {
                arrowPosition = itemW - (screenW - minSpace - point.x)
            }else if point.x < itemW / 2 + minSpace {
                arrowPosition = point.x - minSpace
            }else{
                arrowPosition = itemW / 2
            }
        } else if arrowDirection == .left || arrowDirection == .right {
            
            
        }
    }
    func setRelyRect() {
        if relyRect == CGRect.zero {
            return
        }
        
        if arrowDirection == .top {
            point.y = relyRect.size.height + relyRect.origin.y
        }else if arrowDirection == .bottom {
            point.y = relyRect.origin.y
        }else if arrowDirection == .left {
            point = CGPoint.init(x: relyRect.origin.x + relyRect.size.width, y: relyRect.origin.y + relyRect.size.height / 2)
        }else if arrowDirection == .right {
            point = CGPoint.init(x: relyRect.origin.x + relyRect.size.width, y: relyRect.origin.y + relyRect.size.height / 2)
        }else{ // none
            if isChangeDirection == true {
                point = CGPoint.init(x: relyRect.origin.x + relyRect.size.width/2, y: relyRect.origin.y)
            }else{
                point = CGPoint.init(x: relyRect.origin.x + relyRect.size.width/2, y: relyRect.origin.y + relyRect.size.height )
            }
        }
    }
    
    func setAnchorPoint() {
        if itemW == 0 {
            return
        }
        
        var point = CGPoint.init(x: 0.5, y: 0.5)
        if arrowDirection == .top {
            point = CGPoint.init(x: arrowPosition / itemW, y: 0)
        }else if arrowDirection == .bottom {
            point = CGPoint.init(x: arrowPosition / itemW, y: 1)
        }else if arrowDirection == .left {
            point = CGPoint.init(x: 0 , y: (itemH - arrowPosition) / itemH)
        }else if arrowDirection == .right {
            point = CGPoint.init(x: 0, y: (itemH - arrowPosition) / itemH)
        }else if arrowDirection == .none {
            if isChangeDirection == true{
                point = CGPoint.init(x: arrowPosition / itemW, y: 1)
            }else{
                point = CGPoint.init(x: arrowPosition / itemW, y: 0)
            }
        }
        let originRect = frame
        layer.anchorPoint = point
        frame = originRect
    }
    
    func setOffset() {
        if itemW == 0 {
            return
        }
        
        var originRect = frame
        if arrowDirection == .top {
            originRect.origin.y += offset
        }else if arrowDirection == .bottom {
            originRect.origin.y -= offset
        }else if arrowDirection == .left {
            originRect.origin.y += offset
        }else if arrowDirection == .right {
            originRect.origin.y -= offset
        }
        frame = originRect
    }
    
    //    override open func draw(_ rect: CGRect) {
    //        super.draw(rect)
    //
    ////        let bezierPath = PopupMenuPath.bezierPathWithRect(myRect: rect, rectCorner: self.rectCorner, cornerRadius: cornerRadius, borderW: borderW, borderColor: borderColor, backgroundColor: backColor, arrowW: arrowW, arrowH: arrowH, myArrowPosition: arrowPosition, arrowDirection: arrowDirection)
    ////        bezierPath.fill()
    ////        bezierPath.stroke()
    //    }
}

// MARK: - Private Helpers
extension UIView_popUpMenu {
    @objc func touchOutside() { dismiss() }
    func dismiss() {
        UIView.animate(withDuration: 0.25, animations: {
            self.layer.setAffineTransform(CGAffineTransform.init(scaleX: 0.1, y: 0.1))
            self.alpha = 0
            self.menuBackView.alpha = 0
        }) { (finished) in
            //self.delegate = nil
            self.removeFromSuperview()
            self.menuBackView.removeFromSuperview()
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension UIView_popUpMenu: UITableViewDataSource, UITableViewDelegate {
    // UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    // UITableViewDelegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let item = list[row]
        let cell: PopupMenuCell = tableView.getCell(indexPath)
        
        cell.item = item
        cell.isShowSeparator = (row < (list.count-1))
        cell.configureCell()
        cell.didSelect = {
            self.didSelect?(item, row)
            self.dismiss()
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return itemH
    }
}

// MARK: -
extension UIView_popUpMenu {
}

// MARK: - Public Functions
extension UIView_popUpMenu {
    public static func showOnView(view: UIView, list: [PopUpMenuItem], menuWidth: CGFloat? = nil, didSelect: (Block_didSelect)? = nil) {
        let mainWindow = UIApplication.shared.keyWindow!
        let screenWidth = UIScreen.main.bounds.size.width
        
        let absoluteRect = view.convert(view.bounds, to: mainWindow)
        let relyPoint = CGPoint.init(x: absoluteRect.origin.x + absoluteRect.size.width / 2, y: absoluteRect.origin.y + absoluteRect.size.height/2)
        
        let popUpMenu = UIView_popUpMenu.init()
        popUpMenu.didSelect = didSelect
        popUpMenu.point = relyPoint
        popUpMenu.relyRect = absoluteRect
        let textWidth = list.compactMap({$0.title?.widthOfString($0.titleFont)}).max() ?? 0
        let itemW = menuWidth ?? (16+textWidth+8+24+16+(8))
        popUpMenu.itemW = min(itemW, screenWidth-32)
        popUpMenu.arrowW = 0//12
        popUpMenu.arrowH = 0//12
        popUpMenu.priorityDirection = .top
        popUpMenu.list = list
        
        popUpMenu.updateUI()
        popUpMenu.show()
    }
}

// MARK: - Enums
extension UIView_popUpMenu {
    enum PopupMenuPriorityDirection: Int {
        case top = 0
        case bottom
        case left
        case right
        case none
    }
    enum PopupMenuArrowDirection: Int {
        case top = 0
        case bottom
        case left
        case right
        case none
    }
}

// MARK: - PopUpMenuItem
struct PopUpMenuItem: Equatable {
    let id: String
    let title: String?
    let image: UIImage?
    let titleColor: UIColor
    let titleFont: UIFont = .suisseIntlR(16)
    let textAlignment: NSTextAlignment
    let numberOfLines: Int
    
    // Equatable
    public static func ==(lhs: PopUpMenuItem, rhs: PopUpMenuItem) -> Bool { return lhs.id == rhs.id }
    
    init(title: String? = nil, image: UIImage? = nil, titleColor: UIColor = UIColor("000000"), textAlignment: NSTextAlignment = .left, numberOfLines: Int = 1) {
        self.id = UUID().uuidString
        self.title = title
        self.image = image
        self.titleColor = titleColor
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
    }
}

// MARK: - PopupMenuCell
class PopupMenuCell: UITableViewCell {
    // MARK: - Property - UI
    private(set) lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private(set) lazy var photoImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    private(set) lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private(set) lazy var sepView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor("3C3C43", 0.36)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    // MARK: - Variables
    var item: PopUpMenuItem!
    var isShowSeparator: Bool = true
    var didSelect: (()->Void)?
    
    // MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        self.addTapGesture(self.contentView)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    override func handleTap(_ gestureRecognizer: UITapGestureRecognizer) { didSelect?() }
    
    // MARK: - SetupCell
    func setupViews() {
        self.backgroundColor = .clear
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(photoImageView)
        self.contentView.addSubview(stackView)
        self.contentView.addSubview(sepView)
        
        NSLayoutConstraint.activate([
            // stackView
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            // photoImageView
            photoImageView.widthAnchor.constraint(equalToConstant: 24),
            photoImageView.heightAnchor.constraint(equalToConstant: 24),
            // sepView
            sepView.leftAnchor.constraint(equalTo: self.leftAnchor),
            sepView.rightAnchor.constraint(equalTo: self.rightAnchor),
            sepView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            sepView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    func configureCell() {
        nameLabel.text = item.title
        nameLabel.font = item.titleFont
        nameLabel.textColor = item.titleColor
        nameLabel.textAlignment = item.textAlignment
        nameLabel.numberOfLines = item.numberOfLines
        photoImageView.image = item.image
        photoImageView.isHidden = (item.image == nil)
        sepView.isHidden = !isShowSeparator
    }
}

// MARK: - PopupMenuPath
//let bezierPath = PopupMenuPath.bezierPathWithRect(myRect: rect, rectCorner: UIRectCorner.allCorners, cornerRadius: 5, borderW: borderW, borderColor: .clear, backgroundColor: UIColor("E1E8ED"), arrowW: arrowW, arrowH: arrowH, myArrowPosition: arrowPosition, arrowDirection: arrowDirection)
class PopupMenuPath {
    public static func maskLayerWithRect(rect: CGRect,
                                         rectCorner: UIRectCorner = .allCorners,
                                         cornerRadius: CGFloat = 5,
                                         arrowW: CGFloat,
                                         arrowH: CGFloat,
                                         arrowPosition: CGFloat,
                                         arrowDirection: UIView_popUpMenu.PopupMenuArrowDirection ) -> CAShapeLayer
    {
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.path = bezierPathWithRect(myRect: rect, rectCorner: rectCorner, cornerRadius: cornerRadius, borderW: 0, borderColor: nil, backgroundColor: nil, arrowW: arrowW, arrowH: arrowH, myArrowPosition: arrowPosition, arrowDirection: arrowDirection).cgPath
        return shapeLayer
    }
    
    public static  func bezierPathWithRect(myRect: CGRect,
                                           rectCorner: UIRectCorner = .allCorners,
                                           cornerRadius: CGFloat = 5,
                                           borderW: CGFloat = 0,
                                           borderColor: UIColor? = nil,
                                           backgroundColor: UIColor? = UIColor("E1E8ED"),
                                           arrowW: CGFloat,
                                           arrowH: CGFloat,
                                           myArrowPosition: CGFloat,
                                           arrowDirection: UIView_popUpMenu.PopupMenuArrowDirection) -> UIBezierPath
    {
        let bezierPath = UIBezierPath.init()
        
        if let borderColor = borderColor {
            borderColor.setStroke()
        }
        if let backgroundColor = backgroundColor {
            backgroundColor.setFill()
        }
        bezierPath.lineWidth = borderW
        
        let rect = CGRect.init(x: borderW / 2, y: borderW / 2, width: myRect.size.width - borderW, height: myRect.size.height - borderW)
        
        var topRightRadius : CGFloat = 0
        var topLeftRadius : CGFloat = 0
        var bottomRightRadius : CGFloat = 0
        var bottomLeftRadius : CGFloat = 0
        
        var topRightArcCenter : CGPoint = CGPoint.zero
        var topLeftArcCenter : CGPoint = CGPoint.zero
        var bottomRightArcCenter : CGPoint = CGPoint.zero
        var bottomLeftArcCenter : CGPoint = CGPoint.zero
        
        if rectCorner.contains(UIRectCorner.topLeft) {
            topLeftRadius = cornerRadius
        }
        if rectCorner.contains(UIRectCorner.topRight) {
            topRightRadius = cornerRadius
        }
        if rectCorner.contains(UIRectCorner.bottomLeft) {
            bottomLeftRadius = cornerRadius
        }
        if rectCorner.contains(UIRectCorner.bottomRight) {
            bottomRightRadius = cornerRadius
        }
        
        
        if arrowDirection == .top {
            topLeftArcCenter = CGPoint.init(x: topLeftRadius + rect.origin.x, y: arrowH + topLeftRadius + rect.origin.x)
            topRightArcCenter = CGPoint.init(x: rect.size.width - topRightRadius + rect.origin.x, y: arrowH + topRightRadius + rect.origin.x)
            bottomLeftArcCenter = CGPoint.init(x: bottomLeftRadius + rect.origin.x, y: rect.size.height - bottomLeftRadius + rect.origin.x)
            bottomRightArcCenter = CGPoint.init(x: rect.size.width - bottomRightRadius + rect.origin.x, y: rect.size.height - bottomRightRadius + rect.origin.x)
            var arrowPosition : CGFloat = 0
            if myArrowPosition < topLeftRadius + arrowW / 2 {
                arrowPosition = topLeftRadius + arrowW / 2
            }else if myArrowPosition > rect.size.width - topRightRadius - arrowW / 2 {
                arrowPosition = rect.size.width - topRightRadius - arrowW / 2
            }else{
                arrowPosition = myArrowPosition
            }
            
            bezierPath.move(to: CGPoint.init(x: arrowPosition - arrowW / 2, y: arrowH + rect.origin.x))
            bezierPath.addLine(to: CGPoint.init(x: arrowPosition, y: rect.origin.y + rect.origin.x))
            bezierPath.addLine(to: CGPoint.init(x: arrowPosition + arrowW / 2, y: arrowH + rect.origin.x))
            bezierPath.addLine(to: CGPoint.init(x: rect.size.width - topRightRadius, y: arrowH + rect.origin.x))
            bezierPath.addArc(withCenter: topRightArcCenter, radius: topRightRadius, startAngle: CGFloat.pi * 3 / 2, endAngle: CGFloat.pi * 2, clockwise: true)
            bezierPath.addLine(to: CGPoint.init(x: rect.size.width + rect.origin.x, y: rect.size.height - bottomRightRadius - rect.origin.x))
            bezierPath.addArc(withCenter: bottomRightArcCenter, radius: bottomRightRadius, startAngle: 0, endAngle: CGFloat.pi*0.5, clockwise: true)
            bezierPath.addLine(to: CGPoint.init(x: bottomLeftRadius + rect.origin.x, y: rect.size.height + rect.origin.x))
            
            bezierPath.addArc(withCenter: bottomLeftArcCenter, radius: bottomLeftRadius, startAngle: CGFloat.pi*0.5, endAngle: CGFloat.pi, clockwise: true)
            bezierPath.addLine(to: CGPoint.init(x: rect.origin.x, y: arrowH + topLeftRadius + rect.origin.x))
            bezierPath.addArc(withCenter: topLeftArcCenter, radius: topLeftRadius, startAngle: CGFloat.pi, endAngle: CGFloat.pi * 3 / 2, clockwise: true)
        }else if arrowDirection == .bottom {// 箭头朝下
            
            topLeftArcCenter = CGPoint.init(x: topLeftRadius + rect.origin.x, y: topLeftRadius + rect.origin.x)
            topRightArcCenter = CGPoint.init(x: rect.size.width - topRightRadius + rect.origin.x, y: topRightRadius + rect.origin.x)
            bottomLeftArcCenter = CGPoint.init(x: bottomLeftRadius + rect.origin.x, y: rect.size.height - bottomLeftRadius + rect.origin.x - arrowH)
            bottomRightArcCenter = CGPoint.init(x: rect.size.width - bottomRightRadius + rect.origin.x, y: rect.size.height - bottomRightRadius + rect.origin.x - arrowH)
            var arrowPosition : CGFloat = 0
            if myArrowPosition < bottomLeftRadius + arrowW / 2 {
                arrowPosition = bottomLeftRadius + arrowW / 2
            }else if arrowPosition > rect.size.width - bottomRightRadius - arrowW / 2 {
                arrowPosition = rect.size.width - bottomRightRadius - arrowW / 2
            }else{
                arrowPosition = myArrowPosition
            }
            
            bezierPath.move(to: CGPoint.init(x: arrowPosition + arrowW / 2, y: rect.size.height - arrowH + rect.origin.x))
            bezierPath.addLine(to: CGPoint.init(x: arrowPosition, y: rect.size.height + rect.origin.x))
            bezierPath.addLine(to: CGPoint.init(x: arrowPosition - arrowW / 2, y: rect.size.height - arrowH + rect.origin.x))
            bezierPath.addLine(to: CGPoint.init(x: bottomLeftRadius + rect.origin.x, y: rect.size.height - arrowH + rect.origin.x))
            bezierPath.addArc(withCenter: bottomLeftArcCenter, radius: bottomLeftRadius, startAngle: CGFloat.pi / 2, endAngle: CGFloat.pi, clockwise: true)
            bezierPath.addLine(to: CGPoint.init(x: rect.origin.x, y: topLeftRadius + rect.origin.x))
            bezierPath.addArc(withCenter: topLeftArcCenter, radius: topLeftRadius, startAngle: CGFloat.pi, endAngle: CGFloat.pi * 3 / 2, clockwise: true)
            bezierPath.addLine(to: CGPoint.init(x: rect.size.width - topRightRadius + rect.origin.x, y: rect.origin.x))
            bezierPath.addArc(withCenter: topRightArcCenter, radius: topRightRadius, startAngle: CGFloat.pi * 3 / 2, endAngle: CGFloat.pi * 2, clockwise: true)
            bezierPath.addLine(to: CGPoint.init(x: rect.size.width + rect.origin.x, y: rect.size.height - bottomRightRadius - rect.origin.x - arrowH))
            bezierPath.addArc(withCenter: bottomRightArcCenter, radius: bottomRightRadius, startAngle: 0, endAngle: CGFloat.pi / 2, clockwise: true)
        }else if arrowDirection == .left { // 箭头朝左
            
            topLeftArcCenter = CGPoint.init(x: topLeftRadius + rect.origin.x + arrowH, y: topLeftRadius + rect.origin.x)
            topRightArcCenter = CGPoint.init(x: rect.size.width - topRightRadius + rect.origin.x, y: topRightRadius + rect.origin.x)
            bottomLeftArcCenter = CGPoint.init(x: bottomLeftRadius + rect.origin.x + arrowH, y: rect.size.height - bottomLeftRadius + rect.origin.x)
            bottomRightArcCenter = CGPoint.init(x: rect.size.width - bottomRightRadius + rect.origin.x, y: rect.size.height - bottomRightRadius + rect.origin.x)
            
            var arrowPosition : CGFloat = 0
            if myArrowPosition < topLeftRadius + arrowW / 2 {
                arrowPosition = topLeftRadius + arrowW / 2
            }else if arrowPosition > rect.size.height - bottomLeftRadius - arrowW / 2 {
                arrowPosition = rect.size.height - bottomLeftRadius - arrowW / 2
            }else{
                arrowPosition = myArrowPosition
            }
            
            bezierPath.move(to: CGPoint.init(x: arrowH + rect.origin.x, y: arrowPosition + arrowW / 2))
            bezierPath.addLine(to: CGPoint.init(x: rect.origin.x, y: arrowPosition))
            bezierPath.addLine(to: CGPoint.init(x: arrowH + rect.origin.x, y: arrowPosition - arrowW / 2))
            bezierPath.addLine(to: CGPoint.init(x: arrowH + rect.origin.x, y: topLeftRadius + rect.origin.x))
            bezierPath.addArc(withCenter: topLeftArcCenter, radius: topLeftRadius, startAngle: CGFloat.pi, endAngle: CGFloat.pi*3/2, clockwise: true)
            bezierPath.addLine(to: CGPoint.init(x: rect.size.width - topRightRadius, y: rect.origin.x))
            bezierPath.addArc(withCenter: topRightArcCenter, radius: topRightRadius, startAngle: CGFloat.pi*3/2, endAngle: CGFloat.pi*2, clockwise: true)
            bezierPath.addLine(to: CGPoint.init(x: rect.size.width + rect.origin.x, y: rect.size.height - bottomRightRadius - rect.origin.x))
            bezierPath.addArc(withCenter: bottomRightArcCenter, radius: bottomRightRadius, startAngle: 0, endAngle: CGFloat.pi*0.5, clockwise: true)
            bezierPath.addLine(to: CGPoint.init(x: arrowH + bottomLeftRadius + rect.origin.x, y: rect.size.height + rect.origin.x))
            bezierPath.addArc(withCenter: bottomLeftArcCenter, radius: bottomLeftRadius, startAngle: CGFloat.pi*0.5, endAngle: CGFloat.pi, clockwise: true)
        }else if arrowDirection == .right{ // 箭头朝右
            
            topLeftArcCenter = CGPoint.init(x: topLeftRadius + rect.origin.x, y: topLeftRadius + rect.origin.x)
            topRightArcCenter = CGPoint.init(x: rect.size.width - topRightRadius + rect.origin.x - arrowH, y: topRightRadius + rect.origin.x)
            bottomLeftArcCenter = CGPoint.init(x: bottomLeftRadius + rect.origin.x , y: rect.size.height - bottomLeftRadius + rect.origin.x)
            bottomRightArcCenter = CGPoint.init(x: rect.size.width - bottomRightRadius + rect.origin.x - arrowH, y: rect.size.height - bottomRightRadius + rect.origin.x)
            
            var arrowPosition : CGFloat = 0
            if myArrowPosition < topRightRadius + arrowW / 2 {
                arrowPosition = topRightRadius + arrowW / 2
            }else if arrowPosition > rect.size.height - bottomRightRadius - arrowW / 2 {
                arrowPosition = rect.size.height - bottomRightRadius - arrowW / 2
            }else{
                arrowPosition = myArrowPosition
            }
            
            bezierPath.move(to: CGPoint.init(x: rect.size.width - arrowH + rect.origin.x, y: arrowPosition - arrowW / 2))
            bezierPath.addLine(to: CGPoint.init(x: rect.size.width + rect.origin.x, y: arrowPosition))
            bezierPath.addLine(to: CGPoint.init(x: rect.size.width - arrowH + rect.origin.x, y: arrowPosition + arrowW / 2))
            
            bezierPath.addLine(to: CGPoint.init(x: rect.size.width - arrowH + rect.origin.x, y: rect.size.height - bottomRightRadius - rect.origin.x))
            bezierPath.addArc(withCenter: bottomRightArcCenter, radius: bottomRightRadius, startAngle: 0, endAngle: CGFloat.pi/2, clockwise: true)
            bezierPath.addLine(to: CGPoint.init(x: bottomLeftRadius + rect.origin.x, y: rect.size.height + rect.origin.x))
            bezierPath.addArc(withCenter: bottomLeftArcCenter, radius: bottomLeftRadius, startAngle: CGFloat.pi/2, endAngle: CGFloat.pi, clockwise: true)
            bezierPath.addLine(to: CGPoint.init(x: rect.origin.x, y: arrowH + topLeftRadius + rect.origin.x))
            bezierPath.addArc(withCenter: topLeftArcCenter, radius: topLeftRadius, startAngle: CGFloat.pi, endAngle: CGFloat.pi*0.5*3, clockwise: true)
            bezierPath.addLine(to: CGPoint.init(x: rect.size.width - topRightRadius + rect.origin.x - arrowH, y: rect.origin.x))
            bezierPath.addArc(withCenter: topRightArcCenter, radius: topRightRadius, startAngle: CGFloat.pi*0.5*3, endAngle: CGFloat.pi*2, clockwise: true)
        }else if arrowDirection == .none{ // 无箭头
            
            topLeftArcCenter = CGPoint.init(x: topLeftRadius + rect.origin.x, y: topLeftRadius + rect.origin.x)
            topRightArcCenter = CGPoint.init(x: rect.size.width - topRightRadius + rect.origin.x, y: topRightRadius + rect.origin.x)
            bottomLeftArcCenter = CGPoint.init(x: bottomLeftRadius + rect.origin.x , y: rect.size.height - bottomLeftRadius + rect.origin.x)
            bottomRightArcCenter = CGPoint.init(x: rect.size.width - bottomRightRadius + rect.origin.x, y: rect.size.height - bottomRightRadius + rect.origin.x)
            
            
            bezierPath.move(to: CGPoint.init(x: topLeftRadius + rect.origin.x, y: rect.origin.x))
            bezierPath.addLine(to: CGPoint.init(x: rect.size.width - topRightRadius, y: rect.origin.x))
            
            bezierPath.addArc(withCenter: topRightArcCenter, radius: topRightRadius, startAngle: CGFloat.pi*0.5*3, endAngle: CGFloat.pi*2, clockwise: true)
            
            bezierPath.addLine(to: CGPoint.init(x: rect.size.width + rect.origin.x, y: rect.size.height - bottomRightRadius - rect.origin.x))
            
            bezierPath.addArc(withCenter: bottomRightArcCenter, radius: bottomRightRadius, startAngle: 0, endAngle: CGFloat.pi/2, clockwise: true)
            
            bezierPath.addLine(to: CGPoint.init(x: bottomLeftRadius + rect.origin.x, y: rect.size.height + rect.origin.x))
            
            bezierPath.addArc(withCenter: bottomLeftArcCenter, radius: bottomLeftRadius, startAngle: CGFloat.pi/2, endAngle: CGFloat.pi, clockwise: true)
            
            bezierPath.addLine(to: CGPoint.init(x: rect.origin.x , y: arrowH + topLeftRadius + rect.origin.x))
            bezierPath.addArc(withCenter: topLeftArcCenter, radius: topLeftRadius, startAngle: CGFloat.pi, endAngle: CGFloat.pi*3/2, clockwise: true)
        }
        bezierPath.close()
        return bezierPath
    }
}

// MARK: - used
/*
 private func openPopUpMenu(_ sender: UIView) {
     var itemList: [PopUpMenuItem] = []
     itemList.append(PopUpMenuItem(title: "Вы уже выбирали этот интервал ранее", textAlignment: .center, numberOfLines: 0))
     
     UIView_popUpMenu.showOnView(view: sender, list: itemList, menuWidth: 160)
 }
*/
