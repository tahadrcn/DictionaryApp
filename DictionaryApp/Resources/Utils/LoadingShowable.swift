//
//  LoadingShowable.swift
//  FinalHomework
//
//  Created by Tuba Uzun on 11.06.2024.
//

import UIKit

protocol LoadingShowable where Self: UIViewController{
    func showLoading()
    func hideLoading()
}

extension LoadingShowable{
    func showLoading(){
        LoadingView.shared.startLoading()
    }
    
    func hideLoading() {
        LoadingView.shared.hideLoading()
    }
}
