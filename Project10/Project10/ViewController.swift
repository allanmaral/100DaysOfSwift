//
//  ViewController.swift
//  Project10
//
//  Created by Allan Amaral on 19/08/22.
//

import UIKit

class ViewController: UICollectionViewController {
    var people = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
    }
    
    func askWhichAction(for person: Person, at index: Int) {
        let actionSheetController = UIAlertController(title: "Select a Option", message: nil, preferredStyle: .actionSheet)
        actionSheetController.addAction(UIAlertAction(title: "Rename Person", style: .default) { [weak self] _ in
            self?.askNewName(for: person)
        })
        actionSheetController.addAction(UIAlertAction(title: "Delete Person", style: .destructive) { [weak self] _ in
            self?.removePerson(at: index)
        })
        actionSheetController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(actionSheetController, animated: true)
    }
    
    func askNewName(for person: Person) {
        let alertController = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        alertController.addAction(UIAlertAction(title: "Save", style: .default) { [weak self, weak alertController] _ in
            guard let newName = alertController?.textFields?.first?.text else { return }
            person.name = newName
            self?.collectionView.reloadData()
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alertController, animated: true)
    }
    
    func removePerson(at index: Int) {
        people.remove(at: index)
        collectionView.reloadData()
    }

    // You need to set Estimate Size to none using storyboard
    // in order to make it work properly.
    // See: https://stackoverflow.com/a/38028106
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue PersonCell.")
        }
        
        let person = people[indexPath.item]
        let path = getDocumenstDirectory().appendingPathComponent(person.image)
        let image = UIImage(contentsOfFile: path.path)
        
        cell.name.text = person.name
        cell.imageView.image = image
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        askWhichAction(for: person, at: indexPath.item)
    }
    
    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumenstDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView.reloadData()
        
        dismiss(animated: true)
    }
    
    func getDocumenstDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}

