import Foundation

protocol HomeInteractorProtocol: AnyObject {
    var presenter: HomeInteractorOutputProtocol? { get set }
    func fetchRecentSearches()
    func saveSearch(_ search: String)
    func fetchRecentSearch(at index: Int)
}

protocol HomeInteractorOutputProtocol: AnyObject {
    func didFetchRecentSearches(_ searches: [String])

}

class HomeInteractor: HomeInteractorProtocol {
    weak var presenter: HomeInteractorOutputProtocol?

    private var recentSearches: [String] = []

    func fetchRecentSearches() {
        presenter?.didFetchRecentSearches(recentSearches)
    }

    func saveSearch(_ search: String) {
        recentSearches.removeAll { $0 == search }
        recentSearches.insert(search, at: 0)
        if recentSearches.count > 5 {
            recentSearches.removeLast()
        }
    }

    func fetchRecentSearch(at index: Int) {
            if index < recentSearches.count {
                let search = recentSearches[index]
                presenter?.didFetchRecentSearches([search])
            }
        }

}
