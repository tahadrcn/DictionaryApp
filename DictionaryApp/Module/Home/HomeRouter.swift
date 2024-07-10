import UIKit

enum HomeRoutes {
    case detail
}


protocol HomeRouterProtocol: AnyObject {
    var viewController: UIViewController? { get set }
    static func createModule() -> HomeViewController
    func navigateToDetail(with searchText: String)
}

class HomeRouter: HomeRouterProtocol {
    weak var viewController: UIViewController?

    static func createModule() -> HomeViewController {
        let view = HomeViewController()
        let presenter: HomePresenterProtocol & HomeInteractorOutputProtocol = HomePresenter()
        let interactor: HomeInteractorProtocol = HomeInteractor()
        let router: HomeRouter = HomeRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = view

        return view
    }

    func navigateToDetail(with searchText: String) {
        let detailVC = DetailRouter.createModule(with: searchText)
        viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }
}
