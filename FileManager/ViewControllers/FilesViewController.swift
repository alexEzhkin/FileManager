//
//  FilesViewController.swift
//  FileManager
//
//  Created by Alex on 31.05.22.
//

import UIKit
import PhotosUI

class FilesViewController: UIViewController {
    
    @IBOutlet weak var foldersTableView: UITableView!
    
    var manager = ElementsManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        
        setUpTableView()
        setUpNavigationBar()
    }
    
    private func setUpTableView() {
        foldersTableView.delegate = self
        foldersTableView.dataSource = self
        
        foldersTableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil),
                                  forCellReuseIdentifier: CustomTableViewCell.id)
    }
    
    func setUpNavigationBar() {
        var menuItems: [UIAction] {
            return [
                UIAction(title: "Add folder", image: UIImage(systemName: "folder.fill"), handler: { _ in
                    self.showCreateFolderAlert()
                }),
                UIAction(title: "Add image", image: UIImage(systemName: "photo.fill"), handler: { _ in
                    self.uploadImage()
                }),
                UIAction(title: "Take photo", image: UIImage(systemName: "camera.fill"), handler: { _ in
                    self.uploadCameraPhoto()
                }),
            ]
        }
        
        var demoMenu: UIMenu {
            return UIMenu(title: "Choose your option", image: nil, identifier: nil, options: [], children: menuItems)
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: nil, menu: demoMenu)
    }
    
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
    
    private func uploadCameraPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        
        imagePicker.allowsEditing = true
        
        imagePicker.delegate = self
        
        present(imagePicker, animated: true)
    }
    
    private func uploadImage() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 0
        
        let pickerViewController = PHPickerViewController(configuration: configuration)
        
        pickerViewController.delegate = self
        
        present(pickerViewController, animated: true)
    }
}

extension FilesViewController: ElementsManagerDelegate {
    func reloadData() {
        DispatchQueue.main.async {
            self.foldersTableView.reloadData()
        }
    }
}

extension FilesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImage: UIImage!
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImage = image
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage = image
        }
        
        if (picker.sourceType == UIImagePickerController.SourceType.camera) {
            
            let imgName = UUID().uuidString
            let documentDirectory = NSTemporaryDirectory()
            let localPath = documentDirectory.appending(imgName)
            
            let data = selectedImage.jpegData(compressionQuality: 0.3)! as NSData
            data.write(toFile: localPath, atomically: true)
            let photoURL = URL.init(fileURLWithPath: localPath)
            manager.createImage(selectedImage, name: imgName + ".jpeg")
        }
        picker.dismiss(animated: true)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled")
        
        picker.dismiss(animated: true)
    }
}

extension FilesViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        // Get the first item provider from the results
        guard let itemProvider = results.first?.itemProvider,
              itemProvider.canLoadObject(ofClass: UIImage.self) else {
            return
        }
        
        // Access the UIImage representation for the result
        itemProvider.loadObject(ofClass: UIImage.self) { image, error in
            guard let image = image as? UIImage else {
                return
            }

            self.getImageName(itemProvider: itemProvider) { imageName in
                guard let imageName = imageName else {
                    return
                }
                
                self.manager.createImage(image, name:imageName)
            }
        }
        
        picker.dismiss(animated: true)
    }
    
    private func getImageName(itemProvider: NSItemProvider, callback: @escaping (String?) -> Void) {
        guard itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) else {
            callback(nil)
            return
        }
        
        itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { data, error in
            callback(data?.lastPathComponent)
        }
    }
}
