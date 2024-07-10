import Foundation

protocol WordServiceProtocol {
    func fetchWordDetails(for word: String, completion: @escaping (Result<[WordDetails], NetworkError>) -> Void)
    func fetchSynonyms(for word: String, completion: @escaping (Result<[Synonym], NetworkError>) -> Void)
}
