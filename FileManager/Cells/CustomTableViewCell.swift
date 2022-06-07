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

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func updateData(element: Element) {
        self.cellImageView.image = UIImage(systemName: "folder.fill")
        self.cellLabel.text = element.name
    }
    
}
