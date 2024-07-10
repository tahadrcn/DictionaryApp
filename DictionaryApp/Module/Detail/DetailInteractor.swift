import Foundation

protocol DetailInteractorProtocol: AnyObject {
    var presenter: DetailPresenterProtocol? { get set }
    func fetchWordDetails(for word: String)
    func fetchSynonyms(for word: String)
}

class DetailInteractor: DetailInteractorProtocol {
    weak var presenter: DetailPresenterProtocol?

    func fetchWordDetails(for word: String) {
        let urlString = "https://api.dictionaryapi.dev/api/v2/entries/en/\(word)"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            guard let data = data, error == nil else {
                self.presenter?.didFailToFetchDetails(with: error?.localizedDescription ?? "Unknown error")
                return
            }

            do {
                let wordDetails = try JSONDecoder().decode([WordDetails].self, from: data)
                if let firstWordDetail = wordDetails.first {
                    DispatchQueue.main.async {
                        self.presenter?.didFetchWordDetails(firstWordDetail)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.presenter?.didFailToFetchDetails(with: "No word details found")
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.presenter?.didFailToFetchDetails(with: error.localizedDescription)
                }
            }
        }.resume()
    }

    func fetchSynonyms(for word: String) {
        let urlString = "https://api.datamuse.com/words?rel_syn=\(word)"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            guard let data = data, error == nil else {
                self.presenter?.didFailToFetchSynonyms(with: error?.localizedDescription ?? "Unknown error")
                return
            }

            do {
                let synonyms = try JSONDecoder().decode([Synonym].self, from: data)
                let topSynonyms = synonyms.sorted(by: { $0.score > $1.score }).prefix(5)
                let synonymWords = topSynonyms.map { $0.word } // Extract words from Synonym objects
                DispatchQueue.main.async {
                    self.presenter?.didFetchSynonyms(Array(synonymWords))
                }
            } catch {
                DispatchQueue.main.async {
                    self.presenter?.didFailToFetchSynonyms(with: error.localizedDescription)
                }
            }
        }.resume()
    }

}



