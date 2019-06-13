//
//  VenueTableViewCell.swift
//  TransverseTag
//
//  Created by Gontse Ranoto on 2018/11/13.
//  Copyright © 2018 Gontse Ranoto. All rights reserved.
//

import UIKit

class VenueTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var venueImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
