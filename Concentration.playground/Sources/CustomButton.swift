import UIKit

/**
 A control showing an image with the aspect ratio constrained
 */
class CustomButton: UIControl {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.3 : 1
        }
    }
    
    init(image: UIImage) {
        
        super.init(frame: .zero)
        isOpaque = false // Still needed?
        
        // Set image
        imageView.image = image
        addSubview(imageView)
        
        // Pin image to self
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        // Constrain aspect ratio
        widthAnchor.constraint(equalTo: heightAnchor, multiplier: image.size.width/image.size.height).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
}

