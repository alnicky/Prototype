//
//  ViewController+Extensioins.swift
//  Prototype
//
//  Created by Никита on 4/25/22.
//

import Foundation
import UIKit

extension SecuritiesListViewController {
    func fetchSecurities() {
        
        guard let url = getURL(withQuery: textFromSearch) else { return }
        
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            guard error == nil else {
                print(error?.localizedDescription ?? "noDesciption")
                return
            }
            guard let data = data else { return }
            do {
                self.securities = try JSONDecoder().decode(DataFromSecurities.self, from: data)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
            } catch let error {
                print(error)
            }
        }.resume()
    }
    
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
    
    // MARK: Configuring URL
    
    func getURL(withQuery query: String) -> URL? {
        var components = URLComponents()
        
        components.scheme = "https"
        components.host = "iss.moex.com"
        components.path = "/iss/securities.json"
        components.queryItems = [
            URLQueryItem(name: "q", value: query)
        ]
        
        return components.url
    }
}
