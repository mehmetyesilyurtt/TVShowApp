

import UIKit


class MovieDetailViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var overviewContentLabel: UILabel!
    
    @IBOutlet weak var genresScrollView: UIScrollView!
    
  
    static let identifier = "MovieDetailViewController"
    

    private var viewModel : MovieDetailViewModel!
    
  
    private struct Constants {
        //colors
        static let backgroundColor = UIColor.black
        
        //image size
        static let imageThumbnailSize = "w500"
        
        //keys
        struct Keys {
            static let posterImage : String = "poster_path"
            static let titleMovie : String = "title"
            static let releaseDate : String = "release_date"
            static let overview : String = "overview"
            static let genres : String = "genres"
            static let name : String = "name"
            static let runTime : String = "runtime"
            
        }
        
        //date format
        struct DateFormat {
            static let inputFormatter : String = "YYYY-MM-dd"
            static let outputFormatter : String = "MMM dd, YYYY"
        }

    }
    
    //Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configData()
        configUI()
        
    }
    
    //Public functions
    
    func loadMovieDetail(movieId: Int) {
        viewModel.loadMovieDetail(movieId: movieId) { [weak self] in
            self?.reloadData()
        }
    }
    
    
    //Private functions
  
    private func configData() {
        viewModel = MovieDetailViewModelImpl(movieDetailService: MovieDetailServiceImpl())
    }
    

    /// config UI for detail view
 
    private func configUI() {
        self.view.backgroundColor = Constants.backgroundColor.withAlphaComponent(0.9)
        
        //labels
        movieNameLabel.textColor = .white
        releaseDateLabel.textColor = .white
        overviewLabel.textColor = .white
        overviewContentLabel.textColor = .white
        movieNameLabel.text = ""
        releaseDateLabel.text = ""
        overviewContentLabel.text = ""
        
    }


    /// config detail view

    private func reloadData() {
        //movie title
        movieNameLabel.text = viewModel.movieDictionary[Constants.Keys.titleMovie] as? String ?? ""
        // movie overview
        overviewContentLabel.text = viewModel.movieDictionary[Constants.Keys.overview] as? String ?? ""
        
        //release date
        configureReleaseDate(movieDictionary: viewModel.movieDictionary)
        
        //update image poster
        let posterImageUrlString = viewModel.movieDictionary[Constants.Keys.posterImage] as? String ?? ""
        DispatchQueue.global().async {
            self.loadImage(with: posterImageUrlString)
        }
        
        //genres
        let genres = viewModel.movieDictionary[Constants.Keys.genres] as? [[String: Any]] ?? []
        generateGenres(with: genres)
    }
    
  
    /// Configure Release Date
  
    private func configureReleaseDate(movieDictionary: [String: Any]) {
        //Release date
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
        
        releaseDateLabel.text = movieReleaseDate + " - " + runtimeString
    }
    
    private func minutesToHours (minutes : Int) -> (Int, Int) {
      return (minutes / 60, (minutes % 60))
    }
    

    /// Generate Genres Label

    private func generateGenres(with genres: [[String: Any]]) {
        if genres.count == 0 {
            return
        }
        
        var scrollViewWidth : Int = 0
        var originX : Int = 0
        let originY : Int = 2
        var widthLabel : Int = 80
        let heightLabel : Int = 24
        let padding : Int = 10
        let paddingContentLabel : Int = 16
        for (index, genr) in genres.enumerated() {
            print("Item \(index): \(genr)")
           
            
            let genreName = genr[Constants.Keys.name] as? String ?? ""
         
            widthLabel = Int(genreName.widthOfString(usingFont: UIFont.systemFont(ofSize: 15))) + paddingContentLabel
         
            originX = scrollViewWidth
           
            let frame = CGRect(x: originX, y: originY, width: widthLabel, height: heightLabel)
            let genLabel = UILabel(frame: frame)
            genLabel.layer.masksToBounds = true
            genLabel.layer.cornerRadius = 4
            genLabel.layer.backgroundColor = UIColor.white.cgColor
            
            genLabel.textColor = .black
            genLabel.textAlignment = .center
            genLabel.font = UIFont.systemFont(ofSize: 15)
            
            genLabel.text = genr[Constants.Keys.name] as? String ?? ""
            
            scrollViewWidth += widthLabel+padding
            
       
            genresScrollView.addSubview(genLabel)
        }
        genresScrollView.contentSize = CGSize(width: scrollViewWidth, height: 30)
    }
    
    
    // Image Loading
 
    private func loadImage(with urlString: String) {
        viewModel.loadImage(with: urlString) { (data) in
            guard let data = data
            else { return }
            let image = UIImage(data: data)
            
            DispatchQueue.main.async {[weak self] in
                self?.posterImageView.image = image
            }
        }

    }
    
    //Actions
    
    @IBAction func closeActionClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
