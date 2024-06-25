import UIKit

class UIView_gradientV: UIView {
    // MARK: Public Properties - UI
    @IBInspectable var color0: UIColor = UIColor("3E3843") { didSet { setupLayers() } }
    @IBInspectable var color1: UIColor = UIColor("E6E6E6") { didSet { setupLayers() } }
    // MARK: Public Properties
    // MARK: Private Properties
    override public class var layerClass: Swift.AnyClass { return CAGradientLayer.self }
    
    // MARK: - Initializers
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayers()
    }
        
    // MARK: Private Methods
    private func setupLayers() {
        guard let gradientLayer = self.layer as? CAGradientLayer else { return }
        gradientLayer.colors = [color0.cgColor, color1.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
    }
}

class UIView_gradientVW: UIView {
    // MARK: Public Properties - UI
    @IBInspectable var color0: UIColor = UIColor("FFFFFF") { didSet { setupLayers() } }
    @IBInspectable var color1: UIColor = UIColor("DBDBDB") { didSet { setupLayers() } }
    // MARK: Public Properties
    // MARK: Private Properties
    override public class var layerClass: Swift.AnyClass { return CAGradientLayer.self }
    
    // MARK: - Initializers
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayers()
    }
        
    // MARK: Private Methods
    private func setupLayers() {
        guard let gradientLayer = self.layer as? CAGradientLayer else { return }
        gradientLayer.colors = [color0.cgColor, color1.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.26)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
    }
}
