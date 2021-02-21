//
//  ThirdTableViewCell.swift
//  TestWeatherApp
//
//  Created by Pasha on 19.02.2021.
//

import UIKit

class ThirdTableViewCell: UITableViewCell {
    
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var bottomLineView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bottomLineView.alpha = 0.5
        sunriseLabel.alpha = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
