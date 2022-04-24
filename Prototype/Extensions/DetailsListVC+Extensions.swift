//
//  DetailsListVC+Extesions.swift
//  Prototype
//
//  Created by Никита on 4/24/22.
//

import Foundation

extension DetailsListViewController {
    
    // MARK: Filling the cell with info from securities
    
    func fillCellWithDataFromPaper(cell: SecurityInfoTableViewCell, indexPath: IndexPath) {
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
    
    
    func fetchBoards() {
        let stringUrl = "https://iss.moex.com/iss/securities/\(secid!).json"
        guard let url = URL(string: stringUrl) else { return }
        
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            guard error == nil else {
                print(error?.localizedDescription ?? "noDesciption")
                return
            }
            guard let data = data else { return }
            do {
                self.boards = try JSONDecoder().decode(DataFromBoards.self, from: data)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
            } catch let error {
                print(error)
            }
        }.resume()
    }
    
    
    func fillCellWithBoardsName(cell: BoardCell, indexPath: IndexPath) {
        guard let name = boards?.boards.data[0][2].getStringValue() else { return }
        cell.boardLabel.text = name
    }
}
