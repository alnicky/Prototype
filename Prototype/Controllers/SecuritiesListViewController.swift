//
//  PapaerListViewController.swift
//  Prototype
//
//  Created by Никита on 22.03.2022.
//

import UIKit

class SecuritiesListViewController: UITableViewController {
    
    var securities: DataFromSecurities?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 40
    }


    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return securities?.securities.data.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SecurityCell
        
        guard let securityName = securities?.securities.data[indexPath.row][2].getStringValue()! else { return cell}
    

        cell.securityNameLabel.text = securityName

        return cell
    }
}

extension SecuritiesListViewController {
    func fetchSecurities() {
        guard let url = URL(string: URLs.securities.rawValue) else { return }
        
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
}

extension String {
    static func string(_ value: Paper) -> String {
        guard let stringVal = "\(value)" as? String else { return "" }
        return stringVal
    }
}
