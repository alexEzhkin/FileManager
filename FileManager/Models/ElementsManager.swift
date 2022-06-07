//
//  ElementsManager.swift
//  FileManager
//
//  Created by Alex on 7.06.22.
//

import Foundation

class ElementsManager {
    var elements = [Element]()
    
    var currentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        didSet {
            reloadFolderContents()
        }
    }
    
    var delegate: ElementsManagerDelegate?
    
    init() {
        reloadFolderContents()
    }
    
    func createElement(type: ElementType, name: String) {
        switch type {
        case .folder:
            createFolder(name: name)
        }
    }
    
    private func createFolder(name: String) {
        guard let currentDirectory = currentDirectory else {
            return
        }
        
        // Documents
        // Documens/name
        
        let newFolderPath = currentDirectory.appendingPathComponent(name)
        
        try? FileManager.default.createDirectory(at: newFolderPath,
                                                 withIntermediateDirectories: false,
                                                 attributes: nil)
        reloadFolderContents()
    }
    
    private func reloadFolderContents() {
        guard let currentDirectory = self.currentDirectory,
              let filesUrls = try? FileManager.default.contentsOfDirectory(at: currentDirectory,
                                                                           includingPropertiesForKeys: nil) else {
            return
        }
        
        self.elements = filesUrls.map {
            Element(name: $0.lastPathComponent,
                    path: $0,
                    type: .folder)
        }
        
        delegate?.reloadData()
    }
}
