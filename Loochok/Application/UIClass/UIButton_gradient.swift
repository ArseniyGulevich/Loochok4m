import UIKit

class UIButton_gradientV: UIButton {
    // MARK: Public Properties
    override public class var layerClass: Swift.AnyClass { return CAGradientLayer.self }

    // MARK: - Initializers
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayers()
    }
    
    // MARK: Private Methods
    private func setupLayers() {
        guard let gradientLayer = self.layer as? CAGradientLayer else { return }
        gradientLayer.colors = [UIColor("1F1F1F", 1).cgColor, UIColor("000000", 1)]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        
        gradientLayer.cornerRadius = 8
    }
}
