// DetailRouter.swift

import UIKit

protocol DetailRouterProtocol {
    static func createModule(with word: String) -> DetailViewController
}

class DetailRouter: DetailRouterProtocol {
    static func createModule(with word: String) -> DetailViewController {
        let view = DetailViewController(nibName: "DetailViewController", bundle: nil)
        let presenter: DetailPresenterProtocol = DetailPresenter(word: word)
        let interactor: DetailInteractorProtocol = DetailInteractor()
        let router: DetailRouterProtocol = DetailRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter

        return view
    }
}
