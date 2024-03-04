//
//  MyHistoryCell.swift


import UIKit

class MyHistoryCell: UITableViewCell {

    @IBOutlet weak var myCustomTextView: UITextView!
    @IBOutlet weak var myCustomImageView: UIImageView!
    @IBOutlet weak var myCustomLabelView: UILabel!
    @IBOutlet weak var myFromLabelView: UILabel!
    @IBOutlet weak var myCustomView: UIView!


    override func awakeFromNib() {
        super.awakeFromNib()
        myCustomView.layer.borderWidth = 2
        myCustomView.layer.cornerRadius = 10

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
