//
//  MarketViewController.swift
//  Prototype
//
//  Created by Никита on 18.04.2022.
//

import UIKit

class MarketViewController: UITableViewController {
    
    // MARK: Securities' market data
    
    var marketData: DataFromMarket?
    
    var engine: String?
    var market: String?
    var boardId: String?
    var secid: String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    // MARK: Configure cell
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MarketCell
        fillCellWithMarketData(cell: cell, indexPath: indexPath)
        return cell
    }
}
