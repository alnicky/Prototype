//
//  ViewController.swift
//  Prototype
//
//  Created by Никита on 22.02.2022.
//

import UIKit

enum URLs: String{
    case securities = "https://iss.moex.com/iss/securities.json"
    case boards = "https://iss.moex.com/iss/securities/moex.json"
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loadData" {
            let securityVC = segue.destination as! SecuritiesListViewController
            securityVC.fetchSecurities()
        }
    }

}

