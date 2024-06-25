import UIKit

class UITextView_app: UITextView {
    // MARK: Public Properties - UI
    @IBInspectable open var placeholder: String? { didSet { setNeedsDisplay() } }
    @IBInspectable open var placeholderColor: UIColor = UIColor("828283") { didSet { setNeedsDisplay() } }
    // MARK: Private Properties
    open var attributedPlaceholder: NSAttributedString? { didSet { setNeedsDisplay() } }
    
    // MARK: - Initializers
    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupViews()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    override open func layoutSubviews() {
        super.layoutSubviews()
        setupLayers()
    }
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        showPlaceholderIfNeeded(rect)
    }
    deinit { removeNotificationObserver() }
        
    // MARK: Private Methods
    private func setupLayers() {
    }
    private func setupViews() {
        setupNotificationObserver()
        setup_textView()
    }
}

// MARK: - setupViews
extension UITextView_app {
    private func setup_textView() {
        // property
        //self.round(6)
        //self.textContainerInset = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        // action
        self.addInputAccessoryView(title: "Готово", target: self, selector: #selector(tapDone))
    }
    // MARK: - Actions
    @objc func tapDone() { self.endEditing(true) }
    // Show placeholder if needed
    func showPlaceholderIfNeeded(_ rect: CGRect) {
        guard text.isEmpty else { return }
        
        let xValue = textContainerInset.left + textContainer.lineFragmentPadding
        let yValue = textContainerInset.top
        let width = rect.size.width - xValue - textContainerInset.right
        let height = rect.size.height - yValue - textContainerInset.bottom
        let placeholderRect = CGRect(x: xValue, y: yValue, width: width, height: height)
        
        if let attributedPlaceholder = attributedPlaceholder {
            // Prefer to use attributedPlaceholder
            attributedPlaceholder.draw(in: placeholderRect)
        } else if let placeholder = placeholder {
            // Otherwise user placeholder and inherit `text` attributes
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = textAlignment
            var attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: placeholderColor,
                .paragraphStyle: paragraphStyle
            ]
            if let font = font { attributes[.font] = font }
            
            placeholder.draw(in: placeholderRect, withAttributes: attributes)
        }
    }
}

// MARK: - NotificationCenter
extension UITextView_app {
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(textDidBeginEditing), name: UITextView.textDidBeginEditingNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidEndEditing), name: UITextView.textDidEndEditingNotification, object: self)
    }
    private func removeNotificationObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    // Actions
    @objc func textDidBeginEditing(notification: Notification) {
        guard let sender = notification.object as? UITextView_app, sender == self else { return }
    }
    // Limit the length of text
    @objc func textDidChange(notification: Notification) {
        guard let sender = notification.object as? UITextView_app, sender == self  else { return }
        setNeedsDisplay()
    }
    // Trim white space and new line characters when end editing.
    @objc func textDidEndEditing(notification: Notification) {
        guard let sender = notification.object as? UITextView_app, sender == self else { return }
    }
}
