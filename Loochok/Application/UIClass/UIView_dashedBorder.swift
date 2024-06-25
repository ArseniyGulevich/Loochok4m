import UIKit

class UIView_dashedBorder: UIView {
    // MARK: Public Properties - UI
    @IBInspectable var strokeColor: UIColor = UIColor("000000") { didSet { setupLayers() } }
    // MARK: Private Properties
    private let borderLayer = CAShapeLayer()
    
    // MARK: - Initializers
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayers()
    }
    override func draw(_ rect: CGRect) {
        borderLayer.frame = bounds
        borderLayer.path = UIBezierPath(roundedRect: rect, cornerRadius: self.layer.cornerRadius).cgPath
    }
    
    // MARK: Private Methods
    private func setupLayers() {
        borderLayer.backgroundColor = nil
        borderLayer.fillColor = nil
        borderLayer.lineDashPattern = [4,4]
        borderLayer.lineWidth = 1
        borderLayer.strokeColor = strokeColor.cgColor

        layer.addSublayer(borderLayer)
    }
}
