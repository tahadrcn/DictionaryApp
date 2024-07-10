import Foundation

protocol DetailPresenterProtocol: AnyObject {
    var view: DetailViewProtocol? { get set }
    var interactor: DetailInteractorProtocol? { get set }
    var router: DetailRouterProtocol? { get set }
    var wordDetails: WordDetails? { get } // Eklenen özellik
    
    func viewDidLoad()
    func didFetchWordDetails(_ details: WordDetails?)
    func getAudioURL() -> String?
    func didFailToFetchDetails(with error: String)
    func didFetchSynonyms(_ synonyms: [String])
    func didFailToFetchSynonyms(with error: String)
}

class DetailPresenter: DetailPresenterProtocol {
    weak var view: DetailViewProtocol?
    var interactor: DetailInteractorProtocol?
    var router: DetailRouterProtocol?
    var word: String
    var wordDetails: WordDetails? // Eklenen özellik

    init(word: String) {
        self.word = word
    }
    
    func viewDidLoad() {
        interactor?.fetchWordDetails(for: word)
        interactor?.fetchSynonyms(for: word)
    }

    func didFetchWordDetails(_ details: WordDetails?) {
        wordDetails = details // Kelime detaylarını sakla
        guard let details = details else {
            view?.displayError("No details found for the word.")
            return
        }
        view?.displayWordDetails(details)
    }
    
    func getAudioURL() -> String? {
        print(wordDetails?.audio ?? "yok")
        return wordDetails?.audio
    }

    func didFailToFetchDetails(with error: String) {
        view?.displayError(error)
    }

    func didFetchSynonyms(_ synonyms: [String]) {
        view?.displaySynonyms(synonyms)
    }

    func didFailToFetchSynonyms(with error: String) {
        view?.displayError(error)
    }
}
