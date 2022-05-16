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
                        self.removeLoadingScreen()
                        self.showLossNetworkAlert()
                    }
                }
                return
            }
            guard let data = data else { return }
            do {
                self.boards = try JSONDecoder().decode(DataFromBoards.self, from: data)
                        DispatchQueue.main.async {
                            self.removeLoadingScreen()
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
    
    // MARK: Loading screen
    
    // Show loading screen
    func setLoadingScreen() {
        
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (self.tableView.frame.width / 2) - (width / 2)
        let y = (self.tableView.frame.height / 2) - (height / 2) - (self.navigationController?.navigationBar.frame.height)!
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
        
            
        self.loadingLabel.textColor = .gray
        self.loadingLabel.textAlignment = .center
        self.loadingLabel.text = "Loading..."
        self.loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)
            
        self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        self.activityIndicator.startAnimating()
      
        loadingView.addSubview(self.activityIndicator)
        loadingView.addSubview(self.loadingLabel)
        self.tableView.addSubview(loadingView)
        }
        
    // Hide loading screen
    func removeLoadingScreen() {
        self.activityIndicator.stopAnimating()
        self.loadingLabel.isHidden = true
    }
}
