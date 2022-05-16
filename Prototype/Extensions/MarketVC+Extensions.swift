//
//  MarketVC+Extensions.swift
//  Prototype
//
//  Created by Никита on 4/24/22.
//

import Foundation
import UIKit

extension MarketViewController {
    
    // MARK: Loading and fetching data from market
    
    func fetchMarket() {
        let stringUrl = "https://iss.moex.com/iss/engines/\(engine!)/markets/\(market!)/boards/\(boardId!)/securities/\(secid!).json"
        print("ЗАПРОС НА MARKET \(stringUrl)")
        guard let url = URL(string: stringUrl) else { return }
        
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            guard error == nil else {
                print(error?.localizedDescription ?? "No desciption")
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
                self.marketData = try JSONDecoder().decode(DataFromMarket.self, from: data)
                DispatchQueue.main.async {
                    self.removeLoadingScreen()
                    self.tableView.reloadData()
                }
            } catch let error {
                print(error)
            }
        }.resume()
    }
    
    // MARK: Filling the cell with info from market
    
    func fillCellWithMarketData(cell: MarketCell, indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            if !(marketData?.marketdata.data.isEmpty ?? true),
                let index = marketData?.marketdata.columns.firstIndex(of: "MARKETPRICE") {
                guard let marketPrice = marketData?.marketdata.data[0][index].getDoubleValue() else {
                    cell.marketLabel.text = "Market price: нет информации"
                    return
                }
                cell.marketLabel.text = "Market price: \(marketPrice)"
            } else {
                cell.marketLabel.text = "Market price: нет информации"
            }
        case 1:
            if !(marketData?.marketdata.data.isEmpty ?? true),
                let index = marketData?.marketdata.columns.firstIndex(of: "OPEN") {
                guard let openPrice = marketData?.marketdata.data[0][index].getDoubleValue() else {
                    cell.marketLabel.text = "Open price: нет информации"
                    return
                }
                cell.marketLabel.text = "Open price: \(openPrice)"
            } else {
                cell.marketLabel.text = "Open price: нет информации"
            }
        case 2:
            if !(marketData?.marketdata.data.isEmpty ?? true),
                let index = marketData?.marketdata.columns.firstIndex(of: "LOW") {
                guard let lowPrice = marketData?.marketdata.data[0][index].getDoubleValue() else {
                    cell.marketLabel.text = "Low price: нет информации"
                    return
                }
                cell.marketLabel.text = "Low price: \(lowPrice)"
            } else {
                cell.marketLabel.text = "Low price: нет информации"
            }
        case 3:
            if !(marketData?.marketdata.data.isEmpty ?? true),
                let index = marketData?.marketdata.columns.firstIndex(of: "HIGH") {
                guard let highPrice = marketData?.marketdata.data[0][index].getDoubleValue() else {
                    cell.marketLabel.text = "High price: нет информации"
                    return
                }
                cell.marketLabel.text = "High price: \(highPrice)"
            } else {
                cell.marketLabel.text = "High price: нет информации"
            }
        case 4:
            if !(marketData?.marketdata.data.isEmpty ?? true),
                let index = marketData?.marketdata.columns.firstIndex(of: "LAST") {
                guard let lastPrice = marketData?.marketdata.data[0][index].getDoubleValue() else {
                    cell.marketLabel.text = "Last price: нет информации"
                    return
                }
                cell.marketLabel.text = "Last price: \(lastPrice)"
            } else {
                cell.marketLabel.text = "Last price: нет информации"
            }
        default:
            return
        }
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
    
    // MARK: Updating data from market
         
    @objc func updateData() {
        if NetStatus.shared.isConnected {
            let stringUrl = "https://iss.moex.com/iss/engines/\(engine!)/markets/\(market!)/boards/\(boardId!)/securities/\(secid!).json"
            guard let url = URL(string: stringUrl) else { return }
            
            URLSession.shared.dataTask(with: url) {
                (data, response, error) in
                guard error == nil else {
                    print(error?.localizedDescription ?? "No desciption")
                    DispatchQueue.main.async {
                        self.showLossNetworkAlert()
                    }
                    return
                }
                guard let data = data else { return }
                do {
                    self.marketData = try JSONDecoder().decode(DataFromMarket.self, from: data)
                } catch let error {
                    print(error)
                }
            }.resume()
            DispatchQueue.main.async {
                self.tableView.performBatchUpdates {
                    self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0),
                                                   IndexPath(row: 1, section: 0),
                                                   IndexPath(row: 2, section: 0),
                                                   IndexPath(row: 3, section: 0),
                                                   IndexPath(row: 4, section: 0)],
                                              with: .automatic)
                }
            }
        } else {
            showLossNetworkAlert()
        }
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
