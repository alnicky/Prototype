//
//  ViewController.swift
//  Prototype
//
//  Created by Никита on 22.02.2022.
//

import UIKit
import Network

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var loadDataButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "MOEX"
        
        searchTextField.clearsOnInsertion = true
        searchTextField.clearsOnBeginEditing = true
        searchTextField.keyboardType = .default
        searchTextField.autocorrectionType = .default
        searchTextField.autocapitalizationType = .sentences
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Поиск",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        
        self.hideKeyboardWhenTappedAround()
        self.searchTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchTextField.endEditing(true)
        performSegue(withIdentifier: "loadData", sender: nil)
        return false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loadData" && NetStatus.shared.isConnected &&
            NetStatus.shared.interfaceType != Network.NWInterface.InterfaceType.other {
            if let textForSearch = searchTextField.text, textForSearch.trimmingCharacters(in: .whitespacesAndNewlines).count >= 3 {
                let securityVC = segue.destination as! SecuritiesListViewController
                securityVC.textFromSearch = textForSearch.trimmingCharacters(in: .whitespacesAndNewlines)
                securityVC.fetchSecurities()
            } else {
                showWrongSearhTextAlert()
            }
        } else {
            showLossNetworkAlert()
        }
    }
}

