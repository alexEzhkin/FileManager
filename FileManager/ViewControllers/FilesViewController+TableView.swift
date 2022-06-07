//
//  FilesViewController+TableView.swift
//  FileManager
//
//  Created by Alex on 7.06.22.
//

import UIKit

extension FilesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FilesViewController") as? FilesViewController else {
            return
        }
        
        let element = manager.elements[indexPath.row]
        viewController.manager.currentDirectory = element.path
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension FilesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        manager.elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = manager.elements[indexPath.row]
        
        switch element.type {
        case .folder:
            return getDirectoryCell(tableView, element: element)
        }
    }
    
    private func getDirectoryCell(_ tableView: UITableView, element: Element) -> UITableViewCell {
        guard let tableViewCell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.id) as? CustomTableViewCell else {
                    return UITableViewCell()
        }
        
        tableViewCell.updateData(element: element)
        
        return tableViewCell
    }
}

