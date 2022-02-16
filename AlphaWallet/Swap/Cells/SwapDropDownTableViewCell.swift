//
//  SwapDropDownTableViewCell.swift
//  AlphaWallet
//
//  Created by Mac Pro on 01/12/21.
//

import UIKit

class SwapDropDownTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "SwapDropDownTableViewCell"
    @IBOutlet weak var currencyImageView: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(model: SwapDropDownModel) {
        labelTitle.text = model.title
        currencyImageView.image = model.image
    }
}
