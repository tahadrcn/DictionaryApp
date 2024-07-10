// API.swift
import Foundation

final class API {
    static let shared = API()
    private init() {}

    func fetchWordDetails(for word: String, completion: @escaping (Result<[WordDetails], NetworkError>) -> Void) {
        let urlString = "https://api.dictionaryapi.dev/api/v2/entries/en/\(word)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        let request = URLRequest(url: url)
        executeRequest(request, completion: completion)
    }

    func fetchSynonyms(for word: String, completion: @escaping (Result<[Synonym], NetworkError>) -> Void) {
        let urlString = "https://api.datamuse.com/words?rel_syn=\(word)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        let request = URLRequest(url: url)
        executeRequest(request, completion: completion)
    }

    private func executeRequest<T: Decodable>(_ request: URLRequest, completion: @escaping (Result<T, NetworkError>) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(NetworkError.apiError(error)))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(NetworkError.decodingError))
            }
        }
        task.resume()
    }

    func isConnectedToInternet() -> Bool {
        return Reachability.isConnectedToNetwork()
    }
}

