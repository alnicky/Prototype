//
//  PapaerListViewController.swift
//  Prototype
//
//  Created by Никита on 22.03.2022.
//

import UIKit
import Network

class SecuritiesListViewController: UITableViewController {
    
    var textFromSearch: String!
    
    var securities: DataFromSecurities?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let index = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSecurityDetails" && NetStatus.shared.isConnected &&
            NetStatus.shared.interfaceType != Network.NWInterface.InterfaceType.other {
            let detailsViewController = segue.destination as! DetailsListViewController
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            guard let nameIndex = securities?.securities.columns.firstIndex(of: "shortname") else { return }
            detailsViewController.title = securities?.securities.data[indexPath.row][nameIndex].getStringValue()!
            detailsViewController.paper = (securities?.securities.data[indexPath.row])!
            guard let secidIndex = securities?.securities.columns.firstIndex(of: "secid") else { return }
            detailsViewController.secid = securities?.securities.data[indexPath.row][secidIndex].getStringValue()
            detailsViewController.fetchBoards()
        } else {
            showLossNetworkAlert()
            if let index = self.tableView.indexPathForSelectedRow {
                self.tableView.deselectRow(at: index, animated: true)
            }
        }
    }


    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return securities?.securities.data.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SecurityCell
        
        if let nameIndex = securities?.securities.columns.firstIndex(of: "shortname") {
            if let securityName = securities?.securities.data[indexPath.row][nameIndex].getStringValue()! {
                cell.securityNameLabel.text = securityName
            } else {
                cell.securityNameLabel.text = "No short name in json"
            }
        } else {
            cell.securityNameLabel.text = "No short name column in json"
        }
        
        if let secidIndex = securities?.securities.columns.firstIndex(of: "secid") {
            if let securityName = securities?.securities.data[indexPath.row][secidIndex].getStringValue()! {
                cell.secidLabel.text = securityName
            } else {
                cell.secidLabel.text = "No secid in json"
            }
        } else {
            cell.secidLabel.text = "No secid column in json"
        }
        
        
        return cell
    }
}
