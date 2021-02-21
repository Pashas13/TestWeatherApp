//
//  ThirteenthTableViewCell.swift
//  TestWeatherApp
//
//  Created by Pasha on 20.02.2021.
//

import UIKit

class ThirteenthTableViewCell: UITableViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    override func awakeFromNib() {
     super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
