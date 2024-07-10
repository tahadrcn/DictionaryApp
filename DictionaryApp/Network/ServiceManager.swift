// ServiceManager.swift
import Foundation

class ServiceManager {
    static let shared = ServiceManager()

    func fetchWordDetails(for word: String, completion: @escaping (Result<[WordDetails], NetworkError>) -> Void) {
        API.shared.fetchWordDetails(for: word) { result in
            switch result {
            case .success(let wordDetails):
                completion(.success(wordDetails))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchSynonyms(for word: String, completion: @escaping (Result<[Synonym], NetworkError>) -> Void) {
        API.shared.fetchSynonyms(for: word) { result in
            switch result {
            case .success(let synonyms):
                completion(.success(synonyms))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
