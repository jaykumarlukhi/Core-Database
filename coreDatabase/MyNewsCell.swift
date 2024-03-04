//
//  MyNewsCell.swift


import UIKit

class MyNewsCell: UITableViewCell {
    
    @IBOutlet var myNewsView: UIView!
    @IBOutlet var newsImageView: UIImageView!
    @IBOutlet var newsTitleTextView: UITextView!
    @IBOutlet var newsDescriptionLabelView: UITextView!
    @IBOutlet var newsAuthorLabelView: UILabel!
    @IBOutlet var newsSourceLabelView: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        
        newsImageView.layer.cornerRadius = 8
        myNewsView.layer.borderColor = UIColor.blue.cgColor
        myNewsView.layer.borderWidth = 2
        myNewsView.layer.cornerRadius = 10
        myNewsView.layer.backgroundColor = UIColor(red: 228/255, green: 227/255, blue: 255/255, alpha: 1).cgColor
        
    }
    
 

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
