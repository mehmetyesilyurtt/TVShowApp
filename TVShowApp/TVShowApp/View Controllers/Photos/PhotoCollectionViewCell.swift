
import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
   
    //Class Constants
    
    static let identifier = "PhotoCollectionViewCell"
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // Lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        self.contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor
                .constraint(equalTo: self.contentView.topAnchor),
            imageView.leftAnchor
                .constraint(equalTo: self.contentView.leftAnchor),
            imageView.rightAnchor
                .constraint(equalTo: self.contentView.rightAnchor),
            imageView.bottomAnchor
                .constraint(equalTo: self.contentView.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageView.image = nil
    }

}
