//
//  NinthTableViewCell.swift
//  TestWeatherApp
//
//  Created by Pasha on 19.02.2021.
//

import UIKit

class NinthTableViewCell: UITableViewCell {
    
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var bottomLineView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        precipitationLabel.alpha = 0.5
        bottomLineView.alpha = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
