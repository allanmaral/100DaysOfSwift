//
//  ShoppingListDataSource.swift
//  Challenge2
//
//  Created by Allan Amaral on 08/08/22.
//

import UIKit

class ShoppingListDataSource: NSObject, UITableViewDataSource {
    // MARK: - Properties
    
    private(set) var shoppingList = [String]()
    private var cellIdentifier: String
    private var tableView: UITableView
    
    var formattedList: String {
        shoppingList.joined(separator: "\n")
    }
    
    init(tableView: UITableView, cellIdentifier: String) {
        self.cellIdentifier = cellIdentifier
        self.tableView = tableView
    }
    
    // MARK: - Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
    
    // MARK: - Actions
    
    func add(item: String) {
        shoppingList.append(item)
        let indexPath = IndexPath(row: shoppingList.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func clear() {
        let indexes = shoppingList.indices.map { IndexPath(row: $0, section: 0) }
        shoppingList.removeAll()
        tableView.deleteRows(at: indexes, with: .automatic)
    }
    
}
