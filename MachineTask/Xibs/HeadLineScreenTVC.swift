//
//  HeadLineScreenTVC.swift
//  MachineTask
//
//  Created by ADMIN on 30/11/23.
//

import UIKit

class HeadLineScreenTVC: UITableViewCell {

    @IBOutlet weak var headlineView: UIView!
    @IBOutlet weak var headlineImg: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var authorLbl: UILabel!
    @IBOutlet weak var datelbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        headlineImg.contentMode = .scaleAspectFill
        headlineImg.clipsToBounds = true
        headlineView.layer.cornerRadius = 10
        headlineImg.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
