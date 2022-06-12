//
//  CustomTableViewCell.swift
//  FileManager
//
//  Created by Alex on 2.06.22.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    static let id = "CustomTableViewCell"
    
    
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func updateData(element: Element, selected: Bool) {
        updateImage(element: element)
        
        self.cellLabel.text = element.name
        
        self.backgroundColor = selected ? .yellow : .clear
    }
    
    private func updateImage(element: Element) {
        let image: UIImage?
        
        switch element.type {
        case .folder:
            image = UIImage(systemName: "folder.fill")
            
        case .image:
            guard let data = try? Data(contentsOf: element.path) else {
                return
            }
            
            image = UIImage(data: data)
        }
        
        self.cellImageView.image = image
    }
}
