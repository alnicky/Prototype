//
//  DetailsListViewController.swift
//  Prototype
//
//  Created by Никита on 31.03.2022.
//

import UIKit
import Network

class DetailsListViewController: UITableViewController {
    
    // MARK: Loading indicator

    let loadingView = UIView()
    let activityIndicator = UIActivityIndicatorView()
    let loadingLabel = UILabel()
    
    // MARK: Securities' boards and description (Only the first in data)
    
    var boards: DataFromBoards?
    
    var secid: String!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setLoadingScreen()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows: Int
        
        switch section {
        case 0:
            // Number of lines of information
            numberOfRows = boards?.description.data.count ?? 1
        default:
            // Number of boards fo security
            numberOfRows = 1
        }
        
        return numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        removeLoadingScreen()
        
        switch indexPath.section {
        case 0:
            let infoCell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! SecurityInfoTableViewCell
            
            if let _ = boards?.description.data.count {
                for index in indexPath {
                    guard let title = boards?.description.data[index][1].getStringValue() else { return infoCell }
//                    if title != "Тип бумаги", title != "Код типа инструмента" {
                        guard let type = boards?.description.data[index][3].getStringValue() else { return infoCell }
                        switch type {
                        case "boolean":
                            guard let value = boards?.description.data[index][2].getStringValue() else { return infoCell }
                            if value == "1" {
                                infoCell.infoLabel.text = "\(title): да"
                            } else {
                                infoCell.infoLabel.text = "\(title): нет"
                            }
                        default:
                            guard let value = boards?.description.data[index][2].getStringValue() else { return infoCell }
                            infoCell.infoLabel.text = "\(title): \(value)"
                        }
//                    } else {
//                        infoCell.infoLabel.text = ""
//                    }
                }
            } else  {
                infoCell.infoLabel.text = "Нет информации о бумаге"
            }
            
            return infoCell
        default:
            let boardCell = tableView.dequeueReusableCell(withIdentifier: "boardCell", for: indexPath) as! BoardCell
            
            if let index = boards?.boards.columns.firstIndex(of: "title"),
               let name = boards?.boards.data[0][index].getStringValue() {
                boardCell.boardLabel.text = name
            } else {
                boardCell.boardLabel.text = "Неизвестное название"
            }
            
            return boardCell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0,
                                          y: 0,
                                          width: view.frame.size.width,
                                          height: 40))
        header.backgroundColor = .systemBackground
        
        let label = UILabel(frame: CGRect(x: 16,
                                          y: 5,
                                          width: header.frame.size.width - 16,
                                          height: header.frame.size.height - 10))
        header.addSubview(label)
        
        switch section {
        case 0:
            label.text = "Информация"
        default:
            label.text = "Режимы"
        }
        
        label.font = .boldSystemFont(ofSize: 25)
        
        return header
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDataMarket" && NetStatus.shared.isConnected &&
            NetStatus.shared.interfaceType != Network.NWInterface.InterfaceType.other {
            let marketViewController = segue.destination as! MarketViewController
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            guard let nameIndex = boards?.boards.columns.firstIndex(of: "title") else { return }
            marketViewController.title = boards?.boards.data[indexPath.row][nameIndex].getStringValue()
            guard let engineIndex = boards?.boards.columns.firstIndex(of: "engine") else { return }
            marketViewController.engine = boards?.boards.data[indexPath.row][engineIndex].getStringValue()
            marketViewController.secid = secid
            guard let boardIdIndex = boards?.boards.columns.firstIndex(of: "boardid") else { return }
            marketViewController.boardId = boards?.boards.data[indexPath.row][boardIdIndex].getStringValue()
            guard let marketIndex = boards?.boards.columns.firstIndex(of: "market") else { return }
            marketViewController.market = boards?.boards.data[indexPath.row][marketIndex].getStringValue()
            
            marketViewController.fetchMarket()
        } else {
            showLossNetworkAlert()
            if let index = self.tableView.indexPathForSelectedRow {
                self.tableView.deselectRow(at: index, animated: true)
            }
        }
    }
}
