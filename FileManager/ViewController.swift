//
//  ViewController.swift
//  FileManager
//
//  Created by Alex on 31.05.22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var filesInDocumentDirectory = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFolders()
        
        addCreateFolderBarItem()
        
        tableView.dataSource = self
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "TableViewCell")
    }
    
    func getFolders() {
        let arrayOfFolderURL = FileManager.default.urls(for: .documentDirectory) ?? [URL]()
        for folderURL in arrayOfFolderURL {
            filesInDocumentDirectory.append(folderURL.lastPathComponent)
        }
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

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filesInDocumentDirectory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell",
                                                 for: indexPath)
        cell.textLabel?.text = self.filesInDocumentDirectory[indexPath.row]
        return cell
    }
}

extension FileManager {
    func urls(for directory: FileManager.SearchPathDirectory, skipsHiddenFiles: Bool = true ) -> [URL]? {
        let documentsURL = urls(for: directory, in: .userDomainMask)[0]
        let fileURLs = try? contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: skipsHiddenFiles ? .skipsHiddenFiles : [] )
        return fileURLs
    }
}

