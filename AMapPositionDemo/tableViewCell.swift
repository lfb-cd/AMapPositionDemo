//
//  tableViewCell.swift
//  AMapPositionDemo
//
//  Created by lifubing on 16/11/25.
//  Copyright © 2016年 lifubing. All rights reserved.
//

import UIKit

class tableViewCell: UITableViewCell {

    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
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
