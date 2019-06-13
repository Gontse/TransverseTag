//
//  VenueImageCell.swift
//  TransverseTag
//
//  Created by Gontse Ranoto on 2018/11/18.
//  Copyright © 2018 Gontse Ranoto. All rights reserved.
//

import UIKit

class VenueImageCell: UITableViewCell {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    
    @IBOutlet weak var saveButton: UIButton! {
        didSet{
            saveButton.layer.cornerRadius = 15
            saveButton.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
