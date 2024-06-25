import UIKit

// MARK: - Decorate
extension UIView {
    func decorateView_roundBorder(_ radius: CGFloat? = nil, _ borderColor: UIColor = .black, _ borderWith: CGFloat = 1) {
        let layer = self.layer
        layer.masksToBounds = false
        layer.cornerRadius = radius ?? (frame.height/2)
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWith
    }
    // MARK: - Round
    func round(_ radius: CGFloat? = nil) {
        //self.clipsToBounds = true
        guard let radius = radius else { layer.cornerRadius = frame.height / 2; return }
        layer.cornerRadius = radius
    }
    func roundCorners(_ cornerRadius: Double, _ maskedCorners: CACornerMask) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
        self.layer.maskedCorners = maskedCorners
        //[.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    }
}

// MARK: - Round Corners
extension UIImageView {
    func round_iv(_ radius: CGFloat? = nil) {
        layer.masksToBounds = false
        layer.cornerRadius = (radius != nil) ? radius! : frame.height / 2
        clipsToBounds = true
        //self.layer.borderColor = UIColor.black.cgColor
        //self.layer.borderWidth = 1
    }
}

// MARK: - Support Shadow Layer
extension CALayer {
    func applyShadow(blur: CGFloat, x: CGFloat, y: CGFloat, _ hex: String, _ alpha: CGFloat = 1, _ opacity: Float = 1, _ spread: CGFloat = 0) {
        masksToBounds = false
        shadowColor = UIColor(hex, alpha).cgColor //hexToCGColor(hex, alpha)
        shadowOpacity = opacity
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 { shadowPath = nil }
        else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}

// MARK: - getSubviewsOfView
extension UIView {
    func getSubviewsOfView<T : UIView>(type : T.Type, recursive: Bool = false) -> [T] {
        return self.getSubviewsInner(view: self, recursive: recursive)
    }

    private func getSubviewsInner<T : UIView>(view: UIView, recursive: Bool = false) -> [T] {
        var subviewArray = [T]()
        guard view.subviews.count > 0 else { return subviewArray }
        view.subviews.forEach {
            if recursive { subviewArray += self.getSubviewsInner(view: $0, recursive: recursive) as [T] }
            if let subview = $0 as? T { subviewArray.append(subview) }
        }
        return subviewArray
    }
}

extension UIView {
    func rootView() -> UIView {
        var view = self
        while view.superview != nil { view = view.superview! }
        return view
    }
    
    var isOnWindow: Bool { return self.rootView() is UIWindow }
}

// MARK: - UIStackView
public extension UIStackView {
    /// Sweeter: Remove `subview` from the view hierarchy, not just the stack arrangement.
    func removeArrangedSubviewCompletely(_ subview: UIView) {
        removeArrangedSubview(subview)
        subview.removeFromSuperview()
    }

    /// Sweeter: Remove all arranged subviews from the view hierarchy, not just the stack arrangement.
    func removeAllArrangedSubviewsCompletely() {
        for subview in arrangedSubviews.reversed() {
            removeArrangedSubviewCompletely(subview)
        }
    }
}

// MARK: - Shake
extension UIView {
    func shake() {
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.05
        shake.repeatCount = 2
        shake.autoreverses = true
        let fromPoint = CGPoint(x: center.x - 5, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        shake.fromValue = fromValue
        shake.toValue = toValue
        layer.add(shake, forKey: "position")
    }
    //Use like this:
    //someView.shake()
}
