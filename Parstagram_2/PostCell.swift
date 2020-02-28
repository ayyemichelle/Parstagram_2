//
//  PostCell.swift
//  Parstagram_2
//
//  Created by Michelle Vasquez-Aleman on 2/26/20.
//  Copyright © 2020 Michelle Vasquez-Aleman. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
