//
//  FilesViewController.swift
//  FileManager
//
//  Created by Alex on 31.05.22.
//

import UIKit

class FilesViewController: UIViewController {

    @IBOutlet weak var foldersTableView: UITableView!
    
//    var filesInDocumentDirectory = [String]()
    var manager = ElementsManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        
        setUpTableView()
        setUpNavigationBar()
        
//        getFolders()
        
//        foldersTableView.delegate = self
//        foldersTableView.dataSource = self
//
//        foldersTableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil),
//                           forCellReuseIdentifier: CustomTableViewCell.id)
    }
    
    private func setUpTableView() {
        foldersTableView.delegate = self
        foldersTableView.dataSource = self
        
        foldersTableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil),
                                   forCellReuseIdentifier: CustomTableViewCell.id)
    }
    
//    func getFolders() {
//        filesInDocumentDirectory.removeAll()
//        let arrayOfFolderURL = FileManager.default.urls(for: .documentDirectory) ?? [URL]()
//        for folderURL in arrayOfFolderURL {
//            filesInDocumentDirectory.append(folderURL.lastPathComponent)
//        }
//    }
    
    func setUpNavigationBar() {
        let rightBarButtonItem = UIBarButtonItem(systemItem: .add,
                                                 primaryAction: UIAction(handler: { _ in
            self.showCreateFolderAlert()
        }))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
//    @objc func createFolderAction(){
//        showAlert()
//    }
    
    func showCreateFolderAlert() {
        let messageAlert = UIAlertController(title: "Please, name the folder",
                                             message: "You can enter the name of your folder in this field",
                                             preferredStyle: .alert)
        messageAlert.addTextField()
        
        let createAction = UIAlertAction(title: "Create",
                                         style: .default) { _ in
            guard let folderName = messageAlert.textFields?.first?.text,
                !folderName.isEmpty else {
                self.showCreateFolderAlert()
                
                return
            }
            self.manager.createElement(type: .folder, name: folderName)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel) { _ in
            return
        }
        
        messageAlert.addAction(createAction)
        messageAlert.addAction(cancelAction)
        
        present(messageAlert, animated: true)
    }
    
//    private func createFolder(folderName: String) {
//        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
//            else { return }
//
//        let folderPath = documentDirectory.appendingPathComponent(folderName)
//
//        filesInDocumentDirectory.append(folderPath.lastPathComponent)
//        foldersTableView.reloadData()
//        
//        print(folderPath)
//
//        do {
//            try FileManager.default.createDirectory(at: folderPath,
//                                                    withIntermediateDirectories: true,
//                                                    attributes: nil)
//        }
//        catch {
//            print("Error")
//        }
//    }
}

//extension FilesViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.filesInDocumentDirectory.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let tableViewCell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.id) as? CustomTableViewCell else {
//            return UITableViewCell()
//        }
//        tableViewCell.updateData(text: filesInDocumentDirectory[indexPath.row])
//
//        return tableViewCell
//    }
//}

//extension FilesViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let row = filesInDocumentDirectory[indexPath.row]
//
//        print(row)
//    }
//}
//
//extension FileManager {
//    func urls(for directory: FileManager.SearchPathDirectory, skipsHiddenFiles: Bool = true ) -> [URL]? {
//        let documentsURL = urls(for: directory, in: .userDomainMask)[0]
//        let fileURLs = try? contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: skipsHiddenFiles ? .skipsHiddenFiles : [] )
//        return fileURLs
//    }
//}

extension FilesViewController: ElementsManagerDelegate {
    func reloadData() {
        foldersTableView.reloadData()
    }
}

