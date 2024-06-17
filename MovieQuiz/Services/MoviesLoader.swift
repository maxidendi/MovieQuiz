import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader: MoviesLoading {
    
    //MARK: - NetworkClient
    
    private let netwokClient: NetworkRouting
    
    init(netwokClient: NetworkRouting = NetworkClient()) {
        self.netwokClient = netwokClient
    }
    
    //MARK: - URL
    
    private var mostPopulerMoviesURL: URL {
        guard let url = URL(string: "https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf") else {
            preconditionFailure("Unable to construct mostPopulerMoviesURL")
        }
        return url
    }
    
    //MARK: - Methods
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        netwokClient.fetch(url: mostPopulerMoviesURL) { result in
            switch result {
            case .success(let data):
                do {
                    let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    if !mostPopularMovies.errorMessage.isEmpty {
                        handler(.failure(NetworkErrors.invalidUrlError(mostPopularMovies.errorMessage)))
                    } else {
                        handler(.success(mostPopularMovies))
                    }
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
