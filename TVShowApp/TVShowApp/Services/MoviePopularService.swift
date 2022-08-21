
import Foundation

protocol MoviePopularService : AnyObject {
    func fetchPopularMovies(pageNumber: Int, completion: @escaping ([Any]?) -> Void)
}

class MoviePopularServiceImpl : MoviePopularService {
    
    let moviePopularUrl = "https://api.themoviedb.org/3/discover/movie?api_key=b773377ab7c42ef669c3f0a585dc54e9"
    
    let defaultSession = URLSession(configuration: .default)
    
    var dataTask: URLSessionDataTask?
    var errorMessage = ""
        
    func fetchPopularMovies(pageNumber: Int, completion: @escaping ([Any]?) -> Void) {
        dataTask?.cancel()
        
        guard let url = URL(string: String(format: moviePopularUrl, "\(pageNumber)") ) else {
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
                
                guard let array = response!["results"] as? [Any] else {
                  return
                }
                
                DispatchQueue.main.async {
                    completion(array)
                }
            }
        }
        
        dataTask?.resume()
    }
}
