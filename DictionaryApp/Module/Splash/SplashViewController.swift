//
//  SplashViewController.swift
//  FinalHomework
//
//  Created by Tuba Uzun on 11.06.2024.
//

import UIKit

protocol SplashViewControllerProtocol: AnyObject {
    func noInternetConnection()
}

final class SplashViewController: BaseViewController {

    var presenter: SplashPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        presenter.viewDidAppear()
    }

}

extension SplashViewController: SplashViewControllerProtocol {
    
    func noInternetConnection() {
        showAlert(
            with: "Error",
            message: "No internet connection, please check your connection"
        )
    }
    
    
}
