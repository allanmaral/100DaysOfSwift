//
//  HomeViewController.swift
//  Project7
//
//  Created by Allan Amaral on 11/08/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    var petition: Petition?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = petition?.title
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
