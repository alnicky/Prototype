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
    
    // MARK: Properties for query
    
    var engine: String?
    var market: String?
    var boardId: String?
    var secid: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 20
        }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Timer.scheduledTimer(timeInterval: 5,
                             target: self,
                             selector: #selector(MarketViewController.updateData),
                             userInfo: nil,
                             repeats: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Custom headers
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0,
                                          y: 0,
                                          width: view.frame.size.width,
                                          height: 20))
        header.backgroundColor = .systemBackground
        
        let label = UILabel(frame: CGRect(x: 16,
                                          y: 5,
                                          width: header.frame.size.width - 16,
                                          height: header.frame.size.height + 5))
        header.addSubview(label)
        label.text = "Инофрмация о ценах"
        label.font = .boldSystemFont(ofSize: 22)
        
        return header
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    // MARK: Configure cell
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MarketCell
            fillCellWithMarketData(cell: cell, indexPath: indexPath)
            return cell
    }
}
