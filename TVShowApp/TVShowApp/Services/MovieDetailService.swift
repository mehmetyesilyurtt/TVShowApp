
import Foundation
protocol MovieDetailService : AnyObject {
    func getMovieDetail(movieId: Int, completion: @escaping ([String: Any]?) -> Void)
}

class MovieDetailServiceImpl : MovieDetailService {
    
    let movieDetailUrl = "https://api.themoviedb.org/3/movie/%@?api_key=b773377ab7c42ef669c3f0a585dc54e9"
    
    let defaultSession = URLSession(configuration: .default)
    
    var dataTask: URLSessionDataTask?
    var errorMessage = ""
        
    func getMovieDetail(movieId: Int, completion: @escaping ([String: Any]?) -> Void) {
        dataTask?.cancel()
        
        guard let url = URL(string: String(format: movieDetailUrl, "\(movieId)") ) else {
            return
        }
        
        dataTask = defaultSession.dataTask(with: url) { [weak self] data, response, error in
            defer {
                self?.dataTask = nil
            }
            
            if let error = error {
                self?.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
            } else if let data = data {
                
                var response: [String: Any]?
                
                do {
                  response = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                } catch _ as NSError {
                  return
                }
                
                guard let result = response else {
                  return
                }
                
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
        
        dataTask?.resume()
    }
}
