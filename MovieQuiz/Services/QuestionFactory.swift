import Foundation

final class QuestionFactory: QuestionFactoryProtocol {

    //MARK: - Properties
    
    private var movieLoader: MoviesLoading?
    private var imageLoader: ImageLoading?
    private weak var delegate: QuestionFactoryDelegate?
    private var movies: [MostPopularMovie] = []
    
    init(movieLoader: MoviesLoading?,
         imageLoader: ImageLoading?,
         delegate: QuestionFactoryDelegate?) {
        self.movieLoader = movieLoader
        self.imageLoader = imageLoader
        self.delegate = delegate
    }
    
    //MARK: - Methods

    func loadData() {
        movieLoader?.loadMovies {[weak self] result in
            DispatchQueue.main.async{
                guard let self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            guard let movie = self.movies[safe: index] else { return }
            
            self.imageLoader?.loadImage(imageURL: movie.imageURL) { result in
                switch result {
                case .success(let data):
                    let rating = Float(movie.rating) ?? 0
                    let questionRating = roundf(Float.random(in: 8.0...9.0) * 10) / 10
                    let questionHigherOrLower = Bool.random()
                    let text = questionHigherOrLower ? "Рейтинг этого фильма больше чем \(questionRating)?" :
                                                       "Рейтинг этого фильма меньше чем \(questionRating)?"
                    let correctAnswer = questionHigherOrLower ? rating > questionRating :
                                                                rating < questionRating
                    
                    let question = QuizQuestion(
                        image: data,
                        text: text,
                        correctAnswer: correctAnswer)
                    
                    DispatchQueue.main.async {[weak self] in
                        guard let self else { return }
                        self.delegate?.didReceiveNextQuestion(question: question)
                    }
                case .failure(_):
                    DispatchQueue.main.async {[weak self] in
                        guard let self else { return }
                        self.delegate?.didFailToLoadData(with: NetworkErrors.loadImageError(
                            "Невозможно загрузить фильм \(movie.title)"))
                    }
                }
            }
        }
    }
}
