//
//  ViewController.swift
//  Project7
//
//  Created by Allan Amaral on 09/08/22.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    
    override func loadView() {
        super.loadView()
        title = "Petitions"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBarButtons()
        fetchPetitions()
    }
    
    private func setupBarButtons() {
        let creditsButton = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(creditsTapped))
        let filterButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
        
        navigationItem.leftBarButtonItem = creditsButton
        navigationItem.rightBarButtonItem = filterButton
    }
    
    private func fetchPetitions() {
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        
        showLoadingError()
    }
    
    private func showLoadingError() {
        let alertController = UIAlertController(title: "Loading Error", message: "Failed to load the petitions. Please check your internet connection and try again.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
    private func parse(json: Data) {
        let decoder = JSONDecoder()
        if let jsonPetition = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetition.results
            filteredPetitions = petitions
            tableView.reloadData()
        }
    }
    
    // MARK: - Actions
    
    @objc private func creditsTapped() {
        let alertController = UIAlertController(title: "Credits", message: "This list is fetched from the White House petitions pool", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
    @objc private func searchTapped() {
        let alertController = UIAlertController(title: "Filter", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        alertController.addAction(UIAlertAction(title: "Apply", style: .default) { [weak self, weak alertController] action in
            guard let self = self, let alertController = alertController else { return }
            self.filterPetitions(alertController.textFields?.first?.text)
        })
        present(alertController, animated: true)
    }
    
    private func filterPetitions(_ filter: String?) {
        if let filter = filter {
            filteredPetitions = petitions.filter { $0.title.contains(filter) }
        } else {
            filteredPetitions = petitions
        }
        tableView.reloadData()
    }

}

// MARK: - Table View Delegate and Datasource methods

extension ViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetitions[indexPath.row]
        
        var cellConfiguration = cell.defaultContentConfiguration()
        cellConfiguration.text = petition.title
        cellConfiguration.textProperties.numberOfLines = 1
        cellConfiguration.secondaryText = petition.body
        cellConfiguration.secondaryTextProperties.numberOfLines = 1
        cell.contentConfiguration = cellConfiguration
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        detailViewController.detailItem = filteredPetitions[indexPath.row]
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
}

