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
            action: #selector(createFolder))
        let font = UIFont.systemFont(ofSize: 28)
        let attributes = [NSAttributedString.Key.font : font]
        createFolderBarButtonItem.setTitleTextAttributes(attributes, for: .normal)
        self.navigationItem.rightBarButtonItem  = createFolderBarButtonItem
    }
    
    @objc func createFolder(){
        print("create Folder")
    }

}

