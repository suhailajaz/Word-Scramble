//
//  WordCellTableViewCell.swift
//  Project5-WordScramble
//
//  Created by suhail on 08/07/23.
//

import UIKit

class WordCellTableViewCell: UITableViewCell {
    static let identifier = "WordCellTableViewCell"
    static let nib = UINib(nibName: "WordCellTableViewCell", bundle: nil)
    
    @IBOutlet var vwCellBg: UIView!
    @IBOutlet var lblCurrentWord: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        vwCellBg.layer.cornerRadius = 20
        vwCellBg.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
