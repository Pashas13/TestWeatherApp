//
//  TwelfthTableViewCell.swift
//  TestWeatherApp
//
//  Created by Pasha on 20.02.2021.
//

import UIKit

class TwelfthTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bottomLineView: UIView!
    @IBOutlet weak var uvIndexLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bottomLineView.alpha = 0.5
        uvIndexLabel.alpha = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
