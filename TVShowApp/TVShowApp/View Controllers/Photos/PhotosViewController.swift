
import UIKit

class PhotosViewController: UICollectionViewController {
    
    private var viewModel : PhotosViewModel!
    
    //Lifecycles
    
    public required convenience init(viewModel: PhotosViewModel) {
        self.init(collectionViewLayout: PhotosCollectionViewLayout())
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
    }
    
    private func configUI() {
        self.collectionView.backgroundColor = .white
        self.collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
    }
    
}

extension PhotosViewController {
    
    // UICollectionView DataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        return cell
    }
}

extension PhotosViewController {

    //UICollectionView Delegate
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let cell = cell as? PhotoCollectionViewCell else { return }
        let itemNumber = NSNumber(value: indexPath.item)
        if let cachedImage = self.viewModel.cache.object(forKey: itemNumber) {
            cell.imageView.image = cachedImage
        } else {
            self.viewModel.loadImage(with: viewModel.urlStringImages[indexPath.item]) { [weak self] (image) in
                guard let self = self, let image = image else { return }
                
                cell.imageView.image = image
                self.viewModel.upsertCache(with: image, for: itemNumber)
            
            }
        }
    }
}
