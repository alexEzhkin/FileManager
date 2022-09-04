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
    @IBOutlet weak var filesCollectionView: UICollectionView!
    
    let segmentControl: UISegmentedControl = UISegmentedControl(items: ["Table", "Collection"])
    
    var verificationStatus = false
    
    var manager = ElementsManager()
    
    override func viewWillAppear(_ animated: Bool) {
        checkStatusOfVerification()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        
        updateNavigationButtons()
        
        setUpTableView()
        setUpCollectionView()
        
        enableNotifications()
        
        changingViewCell()
    }
    
    private func updateNavigationButtons() {
        switch manager.mode {
        case .edit:
            addEditModeRightButtons()
            
        case .view:
            setUpNavigationBar()
        }
    }
    
    private func addEditModeRightButtons() {
        let selectButton = UIBarButtonItem(systemItem: .cancel,
                                           primaryAction: UIAction(handler: { _ in
            self.manager.switchMode(.view)
        }))
        
        let deleteButton = UIBarButtonItem(systemItem: .trash,
                                           primaryAction: UIAction(handler: { _ in
            self.manager.deleteSelectedElements()
        }))
        
        navigationItem.rightBarButtonItems = [selectButton, deleteButton]
    }
    
    func setUpNavigationBar() {
        let selectButton = UIBarButtonItem(systemItem: .edit, primaryAction: UIAction(handler: { _ in
            self.manager.switchMode(.edit)
        }))
        
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
        
        segmentControl.sizeToFit()
        segmentControl.selectedSegmentIndex = UserDefaults.standard.integer(forKey: UserDefaultsKey.indexOfDisplayMode.rawValue)
        segmentControl.addTarget(self, action: #selector(FilesViewController.indexChanged(_:)), for: .valueChanged)
        
        self.navigationItem.titleView = segmentControl
        
        let plusButton = UIBarButtonItem(systemItem: .add, primaryAction: nil, menu: demoMenu)
        
        self.navigationItem.rightBarButtonItems = [selectButton, plusButton]
    }
    
    @objc func indexChanged(_ sender: UISegmentedControl) {
        UserDefaults.standard.set(segmentControl.titleForSegment(at: segmentControl.selectedSegmentIndex), forKey: UserDefaultsKey.displayMode.rawValue)
        
        UserDefaultsService.shared.saveSegmentControl(segmentControlIndex: segmentControl.selectedSegmentIndex)
        
        changingViewCell()
    }
    
    func changingViewCell() {
        foldersTableView.isHidden = UserDefaults.standard.bool(forKey: UserDefaultsKey.tableViewSegment.rawValue)
        filesCollectionView.isHidden = UserDefaults.standard.bool(forKey: UserDefaultsKey.collectionViewSegment.rawValue)
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
                                         style: .cancel)
        
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
    
    // MARK: Cells manipulation
    
    func handleCellTap(indexPath: IndexPath) {
        let element = manager.elements[indexPath.row]
        
        switch manager.mode {
        case .edit:
            manager.selectElement(element)
            
        case .view:
            handleViewModeCellTap(element: element)
        }
    }
    
    private func handleViewModeCellTap(element: Element) {
        switch element.type {
        case .folder:
            navigateToNextFolder(element.path)
            
        case .image:
            displayImage(element.path)
        }
    }
    
    private func navigateToNextFolder(_ url: URL) {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FilesViewController") as? FilesViewController else {
            return
        }
        
        viewController.manager.currentDirectory = url
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func displayImage(_ url: URL) {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageViewController") as? ImageViewController else {
            return
        }
        
        viewController.imageURL = url
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension FilesViewController: ElementsManagerDelegate {
    func reloadData() {
        DispatchQueue.main.async {
            self.foldersTableView.reloadData()
            self.filesCollectionView.reloadData()
        }
    }
    
    func handleModeChange() {
        updateNavigationButtons()
        reloadData()
    }
}

extension FilesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage,
              let imageName = (info[.imageURL] as? URL)?.lastPathComponent else {
            return
        }
        
        manager.createImage(image, name: imageName)
        
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
    
    // MARK: - LocalNotificationService manipulations
    
    private func enableNotifications() {
        LocalNotificationsService.shared.requestNotificationsPermissions()
    }
}
