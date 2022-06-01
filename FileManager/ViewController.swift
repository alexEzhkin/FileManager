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
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil),
                           forCellReuseIdentifier: CustomTableViewCell.id)
    }
    
    func getFolders() {
        filesInDocumentDirectory.removeAll()
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
        
        filesInDocumentDirectory.append(folderPath.lastPathComponent)
        tableView.reloadData()
        
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
        guard let tableViewCell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.id) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        tableViewCell.updateData(text: filesInDocumentDirectory[indexPath.row])
        
        return tableViewCell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = filesInDocumentDirectory[indexPath.row]
        
        print(row)
    }
}

extension FileManager {
    func urls(for directory: FileManager.SearchPathDirectory, skipsHiddenFiles: Bool = true ) -> [URL]? {
        let documentsURL = urls(for: directory, in: .userDomainMask)[0]
        let fileURLs = try? contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: skipsHiddenFiles ? .skipsHiddenFiles : [] )
        return fileURLs
    }
}

