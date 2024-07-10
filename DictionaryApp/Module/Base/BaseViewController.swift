//
//  BaseViewController.swift
//  FinalHomework
//
//  Created by Tuba Uzun on 11.06.2024.
//

import UIKit

class BaseViewController: UIViewController ,LoadingShowable{

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    func showAlert ( with title: String, message: String){
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

}
