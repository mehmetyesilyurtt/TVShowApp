

import UIKit

protocol MovieViewModel : AnyObject {
  
   
    var moviePopularArray: [Any] { get }
    var pageNumber : Int { get set }
    var cache : NSCache<NSNumber, UIImage> { get}
    
    
    func upsertCache(with image: UIImage, for itemNumber :NSNumber)
    func loadImage(with urlString: String, completion: @escaping (UIImage?) -> ())
    func fetchPopularMovies(pageNumber: Int, completion: @escaping () -> Void)
    func getMovieDetail(movieId: Int, completion: @escaping ([String: Any]?) -> Void)
}

class MovieViewModelImpl : MovieViewModel {
    
    var pageNumber: Int
    
   
    
    var moviePopularArray: [Any] {
        return _moviePopularArray
    }
    
  
    private var _moviePopularArray: [Any] = []
 
    private var _popularService : MoviePopularService!
    private var _movieDetailService: MovieDetailService!
    
    private let _cache = NSCache<NSNumber, UIImage>()
    private let imageUrl = "https://image.tmdb.org/t/p/%@%@"
    private let utilityQueue = DispatchQueue.global(qos: .utility)
    
    init(popularService: MoviePopularService, movieDetailService: MovieDetailService) {
       
        self._popularService = popularService
        self._movieDetailService = movieDetailService
        self.pageNumber = 1
    }
    
    func fetchPopularMovies(pageNumber: Int, completion: @escaping () -> Void) {
        print("fetchPopularMovies at page number \(pageNumber)")
        _popularService.fetchPopularMovies(pageNumber: pageNumber) {[weak self] (jsonArray) in
            if let jsonArray = jsonArray {
                self?._moviePopularArray.append(contentsOf: jsonArray)
            }
            completion()
            
        }
    }
    

    
    
    func getMovieDetail(movieId: Int, completion: @escaping ([String : Any]?) -> Void) {
        _movieDetailService.getMovieDetail(movieId: movieId, completion: completion)
    }
    

  
    var cache: NSCache<NSNumber, UIImage> {
        return _cache
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
}
