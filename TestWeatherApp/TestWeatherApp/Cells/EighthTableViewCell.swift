//
//  EighthTableViewCell.swift
//  TestWeatherApp
//
//  Created by Pasha on 19.02.2021.
//

import UIKit

class EighthTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bottomLineView: UIView!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bottomLineView.alpha = 0.5
        feelsLikeLabel.alpha = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
