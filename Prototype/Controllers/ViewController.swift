//
//  ViewController.swift
//  Prototype
//
//  Created by Никита on 22.02.2022.
//

import UIKit
import Network

enum URLs: String{
    case securities = "https://iss.moex.com/iss/securities.json"
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loadData" && NetStatus.shared.isConnected &&
            NetStatus.shared.interfaceType != Network.NWInterface.InterfaceType.other {
            let securityVC = segue.destination as! SecuritiesListViewController
            securityVC.fetchSecurities()
        } else {
            showLossNetworkAlert()
        }
    }

}

