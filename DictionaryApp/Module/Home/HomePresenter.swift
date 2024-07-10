import Foundation

protocol HomePresenterProtocol: AnyObject {
    var view: HomeViewProtocol? { get set }
    var interactor: HomeInteractorProtocol? { get set }
    var router: HomeRouterProtocol? { get set }
    func viewDidLoad()
    func searchButtonTapped(with searchText: String)
    func didFetchRecentSearches(_ searches: [String])
    func didSelectRecentSearch(_ search: String)


}

class HomePresenter: HomePresenterProtocol, HomeInteractorOutputProtocol {
    
    weak var view: HomeViewProtocol?
    var interactor: HomeInteractorProtocol?
    var router: HomeRouterProtocol?
    
    func viewDidLoad() {
        interactor?.fetchRecentSearches()
    }
    
    func searchButtonTapped(with searchText: String) {
        interactor?.saveSearch(searchText)
        router?.navigateToDetail(with: searchText)
    }
    
    func didSelectRecentSearch(_ search: String) {
        router?.navigateToDetail(with: search)
    }
    
    func didFetchRecentSearches(_ searches: [String]) {
        view?.displayRecentSearches(searches)
    }
}

