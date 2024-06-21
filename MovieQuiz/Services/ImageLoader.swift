import Foundation

protocol ImageLoading {
    func loadImage(imageURL: URL, handler: @escaping (Result<Data, Error>) -> Void)
}

struct ImageLoader: ImageLoading {
    
    //MARK: - NetworkClient
    
    private let netwokClient: NetworkRouting
    
    init(netwokClient: NetworkRouting = NetworkClient()) {
        self.netwokClient = netwokClient
    }
    
    //MARK: - Methods
    
    func loadImage(imageURL: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        netwokClient.fetch(url: imageURL) { result in
            switch result {
            case .success(let data):
                handler(.success(data))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
