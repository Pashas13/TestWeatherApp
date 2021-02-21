//
//  SecondTableViewCell.swift
//  TestWeatherApp
//
//  Created by Pasha on 18.02.2021.
//

import UIKit

class SecondTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var bottomLineView: UIView!
    @IBOutlet weak var topLineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bottomLineView.alpha = 0.5
        topLineView.alpha = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
