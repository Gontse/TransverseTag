//
//  VenueDetailTableViewCell.swift
//  TransverseTag
//
//  Created by Gontse Ranoto on 2018/11/18.
//  Copyright © 2018 Gontse Ranoto. All rights reserved.
//

import UIKit

class VenueDetailIconCell: UITableViewCell {

    //iconImageView
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
