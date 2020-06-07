//
//  UIViewController+Extension.swift
//  WeatherApp
//
//  Created by Admin on 2020/06/07.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import UIKit


protocol SingleButtonDialogPresenter {
    func presentSingleButtonDialog(alert: SingleButtonAlert)
}


extension UIViewController {
    
    func presentSingleButtonDialog(alert: SingleButtonAlert) {
        let alertController = UIAlertController(title: alert.title,
                                                message: alert.message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: alert.action.buttonTitle,
                                                style: .default,
                                                handler: { _ in alert.action.handler?() }))
        self.present(alertController, animated: true, completion: nil)
    }
}

extension UIViewController{
    
    func showInternetAlert() {
        let okAlert = SingleButtonAlert (
            title: "Could not connect to  network and try again later",
            message: "Failed to update information.",
            action: AlertAction(buttonTitle: "OK", handler: { print("Ok pressed!") })
        )
        presentSingleButtonDialog(alert: okAlert)
    }
    
    func showLocationAlert(){
        let locationAlert = SingleButtonAlert (
            title: "Could not find location",
            message: "Enable location for this App. Go to setting page",
            action: AlertAction(buttonTitle: "OK", handler: { print("Ok pressed!") }))
        presentSingleButtonDialog(alert: locationAlert)
    }
    
}
