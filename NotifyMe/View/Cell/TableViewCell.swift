//
//  TableViewCell.swift
//  NotifyMe
//
//  Created by RASHED on 10/7/22.
//

import UIKit

class TableViewCell: UITableViewCell {
    //IBoutlet
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var phoneNumberLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpUI()
    }
    
    func setUpUI() {
        cellView.layer.cornerRadius = 10
        cellView.layer.borderColor = UIColor(red: 0.49, green: 0.49, blue: 0.49, alpha: 1.00).cgColor
        cellView.layer.borderWidth = 0.3
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
