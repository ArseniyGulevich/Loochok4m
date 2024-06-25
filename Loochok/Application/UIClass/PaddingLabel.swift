import UIKit

//@IBDesignable
class PaddingLabel: UILabel {
    var topInset: CGFloat = 8
    var bottomInset: CGFloat = 8
    var leftInset: CGFloat = 8
    var rightInset: CGFloat = 8

    // MARK: - Initializers
//    override public init(frame: CGRect) {
//        super.init(frame: frame)
//    }
    required init(withInsets top: CGFloat, _ bottom: CGFloat,_ left: CGFloat,_ right: CGFloat) {
        self.topInset = top
        self.bottomInset = bottom
        self.leftInset = left
        self.rightInset = right
        super.init(frame: CGRect.zero)
    }
    required init?(coder aDecoder: NSCoder) {
        //super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += topInset + bottomInset
            contentSize.width += leftInset + rightInset
            return contentSize
        }
    }
}


/*
 https://johncodeos.com/how-to-add-padding-in-uilabel-in-ios-using-swift/
 https://gist.github.com/konnnn/d43af3bd525bb4c58f5c29fb14575b0d
 */
class UILabel_padding: UILabel {
    
    var insets = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
    
    /// Добавляет отступы
    func padding(_ top: CGFloat, _ bottom: CGFloat, _ left: CGFloat, _ right: CGFloat) {
        self.frame = CGRect(x: 0, y: 0, width: self.frame.width + left + right, height: self.frame.height + top + bottom)
        insets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += insets.top + insets.bottom
            contentSize.width += insets.left + insets.right
            return contentSize
        }
    }
}
