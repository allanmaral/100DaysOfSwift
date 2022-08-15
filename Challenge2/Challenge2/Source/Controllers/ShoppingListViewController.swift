//
//  ShoppingListTableViewController.swift
//  Challenge2
//
//  Created by Allan Amaral on 08/08/22.
//

import UIKit

class ShoppingListViewController: UIViewController {
    
    // MARK: - Properties
    let cellIdentifier = "ShoppingItem"
    var dataSource: ShoppingListDataSource!
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    override func loadView() {
        super.loadView()
        title = "Shopping List"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupTableView()
        setupAddItemButton()
    }
    
    private func setupTableView() {
        dataSource = ShoppingListDataSource(tableView: tableView, cellIdentifier: cellIdentifier)
        tableView.dataSource = dataSource
    }
    
    private func setupAddItemButton() {
        let addItemButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForItem))
        let clearListButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clearList))
        let shareListButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        navigationItem.rightBarButtonItems = [addItemButton, shareListButton, clearListButton]
    }
    
    private func addItemToList(_ item: String) {
        dataSource.add(item: item)
    }
    
    @objc private func promptForItem() {
        let alertController = UIAlertController(title: "Enter item name", message: nil, preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "Add", style: .default) { [weak self, weak alertController] _ in
            guard let itemName = alertController?.textFields?.first?.text else { return }
            self?.addItemToList(itemName)
        }
        alertController.addTextField()
        alertController.addAction(submitAction)
        
        present(alertController, animated: true)
    }
    
    @objc private func clearList() {
        dataSource.clear()
    }
    
    @objc private func shareTapped() {
        let formattedList = dataSource.formattedList
        let activityViewController = UIActivityViewController(activityItems: [formattedList], applicationActivities: [])
        activityViewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItems?[2]
        present(activityViewController, animated: true)
    }

}
