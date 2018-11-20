//
//  ICHFriendsTableViewCell.swift
//  ichat
//
//  Created by ZHUYN on 2018/11/20.
//  Copyright © 2018年 iChat. All rights reserved.
//

import UIKit

class ICHFriendsTableViewCell: UITableViewCell {

    @IBOutlet var imgView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
