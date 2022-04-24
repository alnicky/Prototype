//
//  BoardsViewController.swift
//  Prototype
//
//  Created by Никита on 16.04.2022.
//

import UIKit

class BoardsViewController: UITableViewController {
    
    // MARK: Security instance's secid
    var secid: String!
    
    // MARK: Data froms security instance's boards (is_primary = 1)
    var boards: DataFromBoards?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDataMarket" {
            let marketViewController = segue.destination as! MarketViewController
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            marketViewController.engine = boards?.boards.data[indexPath.row][7].getStringValue()
            marketViewController.secid = secid
            marketViewController.boardId = boards?.boards.data[indexPath.row][1].getStringValue()
            marketViewController.market = boards?.boards.data[indexPath.row][5].getStringValue()
            
            marketViewController.fetchBoards()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    // MARK: Configure cell
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BoardCell
        fillCellWithBoardsName(cell: cell, indexPath: indexPath)
        return cell
    }

}

extension BoardsViewController {
    
    // MARK: Loading and fetching data from boards
    
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
    
    // MARK: Filling a cell with boards names
    
    func fillCellWithBoardsName(cell: BoardCell, indexPath: IndexPath) {
        for index in (0 ... indexPath.row) {
            guard let name = boards?.boards.data[index][2].getStringValue() else { return }
            cell.boardLabel.text = name
        }
    }
}

