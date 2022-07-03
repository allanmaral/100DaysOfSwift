//
//  DetailViewController.swift
//  Project1
//
//  Created by Allan Amaral on 02/07/22.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var selectedImage: String?
    var imageIndex: Int?
    var imageCount: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let imageIndex = imageIndex, let imageCount = imageCount {
            title = "Picture \(imageIndex + 1) of \(imageCount)"
        }
        navigationItem.largeTitleDisplayMode = .never

        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }

}
