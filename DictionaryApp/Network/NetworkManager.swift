import Foundation

protocol NetworkService {
    func execute<T: Decodable>(urlRequest: URLRequest, completion: @escaping(Result<T, NetworkError>) -> Void)
}

class NetworkManager: NetworkService {
    
    func execute<T: Decodable>(urlRequest: URLRequest, completion: @escaping(Result<T, NetworkError>) -> Void) {
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error.localizedDescription)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.jsonParsingFailed(error.localizedDescription)))
            }
        }
        task.resume()
    }
}
