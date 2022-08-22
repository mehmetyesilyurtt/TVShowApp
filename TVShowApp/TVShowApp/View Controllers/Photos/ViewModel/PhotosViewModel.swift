

import UIKit

protocol PhotosViewModel : AnyObject {
    
    var cache : NSCache<NSNumber, UIImage> { get}
    func upsertCache(with image: UIImage, for itemNumber :NSNumber)
    func loadImage(with urlString: String, completion: @escaping (UIImage?) -> ())
    var numberOfItemsInSection : Int { get }
    var urlStringImages : [String] { get }
}

class PhotosViewModelImpl : PhotosViewModel {

    private var _urlsArray : [String] = []
    private let _cache = NSCache<NSNumber, UIImage>()
    private let utilityQueue = DispatchQueue.global(qos: .utility)
    private let imageUrl = "https://image.tmdb.org/t/p/%@%@"
    
    init(urlsArray: [String]) {
        self._urlsArray = urlsArray
    }
    
    var cache: NSCache<NSNumber, UIImage> {
        return _cache
    }
    
    var urlStringImages : [String] {
        return _urlsArray
    }
    
  
    func upsertCache(with image: UIImage, for itemNumber :NSNumber) {
        _cache.setObject(image, forKey: itemNumber)
    }
    

    func loadImage(with urlString: String, completion: @escaping (UIImage?) -> ()) {
        utilityQueue.async {

            guard let url = URL(string: String(format: self.imageUrl, "w154", urlString)), let data = try? Data(contentsOf: url) else {
                completion(nil)
                return
            }
            let image = UIImage(data: data)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
    var numberOfItemsInSection : Int {
        return _urlsArray.count
    }
    
    
}
