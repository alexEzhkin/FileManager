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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateData(text: String) {
        cellImageView.image = UIImage(systemName: "folder")
        cellLabel.text = text
    }
    
}
