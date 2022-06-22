//
//  FilesViewControlles+CollectionView.swift
//  FileManager
//
//  Created by Alex on 8.06.22.
//

import UIKit

extension FilesViewController {
    var collectionCellSize: CGSize {
        let size = 100
        
        return CGSize(width: size, height: size)
    }
    
    func setUpCollectionView() {
        filesCollectionView.delegate = self
        filesCollectionView.dataSource = self
        
        filesCollectionView.allowsMultipleSelection = true
        
        filesCollectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CustomCollectionViewCell.id)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        handleCellTap(indexPath: indexPath)
    }
}

extension FilesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionCellSize
    }
}

extension FilesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return manager.elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.id, for: indexPath) as? CustomCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let element = manager.elements[indexPath.row]
        
        collectionViewCell.updateData(element: element, selected: manager.selectedElements.contains(element))
        
        return collectionViewCell
    }
}

