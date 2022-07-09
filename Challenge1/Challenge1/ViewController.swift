//
//  ViewController.swift
//  Challenge1
//
//  Created by Allan Amaral on 09/07/22.
//

import UIKit

class ViewController: UITableViewController {
    var flags = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Flag Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        flags = items.filter { $0.hasSuffix(".png") }.sorted()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        flags.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Flag", for: indexPath)
        let flag = flags[indexPath.row]
        cell.textLabel?.text = flag.replacingOccurrences(of: ".png", with: "")
        cell.imageView?.image = UIImage(named: flags[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFlag = flags[indexPath.row]
        
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            viewController.selectedFlag = selectedFlag
            navigationController?.pushViewController(viewController, animated: true)
        }
    }

}

