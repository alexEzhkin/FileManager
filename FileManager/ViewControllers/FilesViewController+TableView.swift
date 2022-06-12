//
//  FilesViewController+TableView.swift
//  FileManager
//
//  Created by Alex on 7.06.22.
//

import UIKit

extension FilesViewController: UITableViewDelegate {
    func setUpTableView() {
        foldersTableView.delegate = self
        foldersTableView.dataSource = self
        
        foldersTableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil),
                                  forCellReuseIdentifier: CustomTableViewCell.id)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleCellTap(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}

extension FilesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        manager.elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = manager.elements[indexPath.row]
        
        switch element.type {
        case .folder, .image:
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

