

import UIKit


//  Movie Cell

class MovieCell: UITableViewCell {
    
    

    
    static let identifier = "MovieCell"
     
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var rating: RatingView!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var favButton: UIButton!
    
    private var myID = -1
    private struct Constants {
      
        struct Keys {
            static let titleMovie : String = "title"
            static let releaseDate : String = "release_date"
            static let voteAverage : String = "vote_average"
            static let runTime : String = "runtime"
        }
        
  
        struct DateFormat {
            static let inputFormatter : String = "YYYY-MM-dd"
            static let outputFormatter : String = "MMM dd, YYYY"
        }

    }
    
    //Public functions
    
    func configure(movieDictionary: [String: Any]) {
        
        //Update UI
        title.textColor = .white
        releaseDate.textColor = .white
        self.backgroundColor = .clear
        
        //Update Data
        
        title.text = movieDictionary[Constants.Keys.titleMovie] as? String ?? ""
        releaseDate.text = ""
         
        let movieId = movieDictionary["id"] as? Int ?? 1
        print(movieId)
        myID = movieId
        if(IsExistInFavorites(movieId: movieId)){
            favButton.setImage(UIImage(named: "favFilled"), for: .normal)
        }else {
            favButton.setImage(UIImage(named: "favEmpty"), for: .normal)

        }
            
        
        let voteAverage : Double = movieDictionary[Constants.Keys.voteAverage] as? Double ?? 0
        rating.updateCirclePercentage(percent: voteAverage)
        
    }
    
    func configure(movieId: Int, viewModel: MovieViewModel) {
        viewModel.getMovieDetail(movieId: movieId) {[weak self] (movieDetail) in
            if let movieDetail = movieDetail {
                self?.configureReleaseDate(movieDictionary: movieDetail)
            }
        }
    }
    
    func configureImage( _ image : UIImage) {
        poster.image = image
    }
    
    // Private functions
    
 
    private func configureReleaseDate(movieDictionary: [String: Any]) {
       
        let releaseDateString = movieDictionary[Constants.Keys.releaseDate] as? String ?? ""
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = Constants.DateFormat.inputFormatter
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = Constants.DateFormat.outputFormatter
        guard let showDate = inputFormatter.date(from: releaseDateString) else { return }
        let movieReleaseDate = outputFormatter.string(from: showDate)
        
        //Run time value
        
        let movieRunTime = movieDictionary[Constants.Keys.runTime] as? Int ?? 0
        let (hour, minutes) = minutesToHours(minutes: movieRunTime)
        let runtimeString = "\(hour)h \(minutes)m"
        releaseDate.text = movieReleaseDate + " - " + runtimeString
    }
    
    @IBAction func favClicked(_ sender: Any) {
        if(IsExistInFavorites(movieId: myID)){
            RemoveFromFavorites(movieId: myID)
            favButton.setImage(UIImage(named: "favEmpty"), for: .normal)
        }else{
            favButton.setImage(UIImage(named: "favFilled"), for: .normal)
            AddToFavorites(movieId: myID)
        }
    }
    private func minutesToHours (minutes : Int) -> (Int, Int) {
      return (minutes / 60, (minutes % 60))
    }
    

}
