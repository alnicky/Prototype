//
//  DetailsListVC+Extesions.swift
//  Prototype
//
//  Created by Никита on 4/24/22.
//

import Foundation
import UIKit

extension DetailsListViewController {
    
    func fetchBoards() {
        let stringUrl = "https://iss.moex.com/iss/securities/\(secid!).json"
        print("ЗАПРОС НА BOARDS \(stringUrl)")
        guard let url = URL(string: stringUrl) else { return }
        
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            guard error == nil else {
                print(error?.localizedDescription ?? "noDesciption")
                if (error as? URLError)?.code == .timedOut {
                    DispatchQueue.main.async {
                        self.showLossNetworkAlert()
                    }
                }
                return
            }
            guard let data = data else { return }
            do {
                self.boards = try JSONDecoder().decode(DataFromBoards.self, from: data)
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
}
