//
//  MarketVC+Extensions.swift
//  Prototype
//
//  Created by Никита on 4/24/22.
//

import Foundation

extension MarketViewController {
    
    // MARK: Loading and fetching data from market
    
    func fetchBoards() {
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
    
    func fillCellWithMarketData(cell: MarketCell, indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            if let index = marketData?.marketdata.columns.firstIndex(of: "MARKETPRICE") {
                guard let marketPrice = marketData?.marketdata.data[0][index].getDoubleValue() else { return }
                cell.marketLabel.text = "Market price: \(marketPrice)"
            } else {
                cell.marketLabel.text = "No info about market price"
            }
//            guard let index = marketData?.marketdata.columns.firstIndex(of: "MARKETPRICE") else { return }
//            guard let marketPrice = marketData?.marketdata.data[0][index].getDoubleValue() else { return }
//            cell.marketLabel.text = "Market price: \(marketPrice)"
        case 1:
            guard let index = marketData?.marketdata.columns.firstIndex(of: "OPEN") else { return }
            guard let openPrice = marketData?.marketdata.data[0][index].getDoubleValue() else { return }
            cell.marketLabel.text = "Open price: \(openPrice)"
        default:
            return
        }
    }
    
}
