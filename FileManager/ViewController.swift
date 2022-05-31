//
//  ViewController.swift
//  FileManager
//
//  Created by Alex on 31.05.22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addCreateFolderBarItem()
    }
    
    func addCreateFolderBarItem() {
        let createFolderBarButtonItem = UIBarButtonItem(
            title: NSString(string: "+") as String,
            style: .done,
            target: self,
            action: #selector(createFolderAction))
        let font = UIFont.systemFont(ofSize: 28)
        let attributes = [NSAttributedString.Key.font : font]
        createFolderBarButtonItem.setTitleTextAttributes(attributes, for: .normal)
        self.navigationItem.rightBarButtonItem  = createFolderBarButtonItem
    }
    
    @objc func createFolderAction(){
        showAlert()
    }
    
    func showAlert() {
        let messageAlert = UIAlertController(title: "Please, name the folder",
                                             message: "You can enter the name of your folder in this field",
                                             preferredStyle: .alert)
        messageAlert.addTextField()
        
        let createAction = UIAlertAction(title: "Create",
                                         style: .default) { _ in
            let folderName = messageAlert.textFields?.first?.text ?? "folder"
            print(folderName)
            self.createFolder(folderName: folderName)
            return
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel) { _ in
            return
        }
        
        messageAlert.addAction(createAction)
        messageAlert.addAction(cancelAction)
        
        present(messageAlert, animated: true)
    }
    
    private func createFolder(folderName: String) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            else { return }
        
        let folderPath = documentDirectory.appendingPathComponent(folderName)
        
        print(folderPath)
        
        do {
            try FileManager.default.createDirectory(at: folderPath,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
        }
        catch {
            print("Error")
        }
    }
    
}

