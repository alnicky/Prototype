//
//  DetailsListViewController.swift
//  Prototype
//
//  Created by Никита on 31.03.2022.
//

import UIKit

class DetailsListViewController: UITableViewController {
    
    var paper: [Paper] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SecurityInfoTableViewCell
        
        fillCell(cell: cell, indexPath: indexPath)
        
        return cell
    }
}

extension DetailsListViewController {
    func fillCell(cell: SecurityInfoTableViewCell, indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            guard let name = paper[4].getStringValue() else { return }
            cell.infoLabel.text = "Название: \(name)"
        case 1:
            guard let secId = paper[1].getStringValue() else { return }
            cell.infoLabel.text = "Код ценной бумаги: \(secId)"
        case 2:
            guard let regNumber = paper[3].getStringValue() else { return }
            cell.infoLabel.text = "Номер государственной регистрации: \(regNumber)"
        case 3:
            guard let isin = paper[5].getStringValue() else { return }
            cell.infoLabel.text = "ISIN: \(isin)"
        case 4:
            guard let isTraded = paper[6].getIntValue() else { return }
            if isTraded == 1 {
                cell.infoLabel.text = "Торгуется: да"
            } else {
                    cell.infoLabel.text = "Торгуется: нет"
            }
        case 5:
            guard let emitentId = paper[7].getIntValue() else { return }
            cell.infoLabel.text = "ID эмитента: \(emitentId)"
        case 6:
            guard let emitentTitle = paper[8].getStringValue() else { return }
            cell.infoLabel.text = "Название эмитента: \(emitentTitle)"
        case 7:
            guard let emitentInn = paper[9].getStringValue() else { return }
            cell.infoLabel.text = "ИНН эмитента: \(emitentInn)"
        case 8:
            guard let emitentOkpo = paper[10].getStringValue() else { return }
            cell.infoLabel.text = "ОКПО эмитента: \(emitentOkpo)"
        case 9:
            guard let gosregNumber = paper[11].getStringValue() else { return }
            cell.infoLabel.text = "Государственный регистрационный номер: \(gosregNumber)"
        case 10:
            guard let type = paper[12].getStringValue() else { return }
            if type == "common_share" {
                cell.infoLabel.text = "Тип бумаги: простая акция"
            } else {
                cell.infoLabel.text = "Тип бумаги: опцион"
            }
        case 11:
            guard let group = paper[13].getStringValue() else { return }
            if group == "stock_shares" {
                cell.infoLabel.text = "Группа: акции и облигации"
            } else {
                cell.infoLabel.text = "Группа: фьючерсные опционы"
            }
        default:
            return
        }
    }
}
