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
        print(stringUrl)
        guard let url = URL(string: stringUrl) else { return }
        
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            guard error == nil else {
                print(error?.localizedDescription ?? "noDesciption")
                return
            }
            guard let data = data else { return }
            do {
                self.marketData = try JSONDecoder().decode(DataFromMarket.self, from: data)
                        DispatchQueue.main.async {
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
            if let index = marketData?.marketdata.columns.firstIndex(of: "MARKETPRICE") {
                guard let marketPrice = marketData?.marketdata.data[0][index].getDoubleValue() else { return }
                cell.marketLabel.text = "Market price: \(marketPrice)"
            } else {
                cell.marketLabel.text = "No info about market price"
            }
        case 1:
            if let index = marketData?.marketdata.columns.firstIndex(of: "OPEN") {
                guard let openPrice = marketData?.marketdata.data[0][index].getDoubleValue() else { return }
                cell.marketLabel.text = "Open price: \(openPrice)"
            } else {
                cell.marketLabel.text = "No info about open price"
            }
        case 2:
            if let index = marketData?.marketdata.columns.firstIndex(of: "LOW") {
                guard let lowPrice = marketData?.marketdata.data[0][index].getDoubleValue() else { return }
                cell.marketLabel.text = "Low price: \(lowPrice)"
            } else {
                cell.marketLabel.text = "No info about low price"
            }
        case 3:
            if let index = marketData?.marketdata.columns.firstIndex(of: "HIGH") {
                guard let highPrice = marketData?.marketdata.data[0][index].getDoubleValue() else { return }
                cell.marketLabel.text = "High price: \(highPrice)"
            } else {
                cell.marketLabel.text = "No info about high price"
            }
        case 4:
            if let index = marketData?.marketdata.columns.firstIndex(of: "LAST") {
                guard let lastPrice = marketData?.marketdata.data[0][index].getDoubleValue() else { return }
                cell.marketLabel.text = "Last price: \(lastPrice)"
            } else {
                cell.marketLabel.text = "No info about last price"
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
        if NetStatus.shared.isConnected{
            let stringUrl = "https://iss.moex.com/iss/engines/\(engine!)/markets/\(market!)/boards/\(boardId!)/securities/\(secid!).json"
            guard let url = URL(string: stringUrl) else { return }
            
            URLSession.shared.dataTask(with: url) {
                (data, response, error) in
                guard error == nil else {
                    print(error?.localizedDescription ?? "noDesciption")
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
                self.tableView.reloadData()
            }
        } else {
            showLossNetworkAlert()
        }
    }
    
}
