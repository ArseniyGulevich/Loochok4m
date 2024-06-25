import UIKit

class UIButton_dashedBorder: UIButton {
    // MARK: Public Properties - UI
    @IBInspectable open var borderColor: UIColor = UIColor("000000")
    @IBInspectable open var radius: CGFloat = 8
    // MARK: Public Properties
    // MARK: Private Properties
    private let borderLayer = CAShapeLayer()

    // MARK: - Initializers
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupInit()
        setupLayers()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupInit()
        setupLayers()
    }
    override func draw(_ rect: CGRect) {
        borderLayer.frame = bounds
        borderLayer.path = UIBezierPath(roundedRect: rect, cornerRadius: radius).cgPath
    }
    
    // MARK: Private Methods
    private func setupInit() {
        //self.round(8)
    }
    // MARK: Private Methods
    private func setupLayers() {
        borderLayer.backgroundColor = nil
        borderLayer.fillColor = nil
        borderLayer.lineDashPattern = [4,4]
        borderLayer.lineWidth = 1
        borderLayer.strokeColor = borderColor.cgColor

        layer.addSublayer(borderLayer)
        layer.masksToBounds = false
        layer.cornerRadius = radius
        clipsToBounds = true
    }
}
