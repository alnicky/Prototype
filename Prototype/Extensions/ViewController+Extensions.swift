//
//  ViewController+Extensions.swift
//  Prototype
//
//  Created by Никита on 4/27/22.
//

import Foundation
import UIKit

extension ViewController {
    
    // MARK: Alert
    
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
    
}
