//
//  ViewController+Extensions.swift
//  Prototype
//
//  Created by Никита on 4/27/22.
//

import Foundation
import UIKit

extension ViewController {
    
    // MARK: Alerts
    
    func showLossNetworkAlert() {
            let alert = UIAlertController(title: "Lost connection",
                                          message: "Please connect to network or turn off VPN",
                                          preferredStyle: .alert)
        
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .cancel,
                                          handler: {(_: UIAlertAction!) in
                                            //Sign out action
            }))
        
            self.present(alert, animated: true, completion: nil)
    }
    
    func showWrongSearhTextAlert() {
            let alert = UIAlertController(title: "Incorrect search format",
                                          message: "Please enter at least three characters in the search bar and try again",
                                          preferredStyle: .alert)
        
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .cancel,
                                          handler: {(_: UIAlertAction!) in
                                            //Sign out action
            }))
        
            self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Settings for keyboard
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
