//
//  ProductInfoTableViewCell.swift
//  ChallengeMeli
//
//  Created by Carlos Raymundo Tijerino Capetillo on 14/04/22.
//

import UIKit

class ProductInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var lblAttributeName: UILabel!
    @IBOutlet weak var lblAttributeValue: UILabel!
    @IBOutlet weak var viewAttributeName: UIView!
    @IBOutlet weak var viewAttributeValue: UIView!
    
    //MARK: -
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    //MARK: -
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    //MARK: -
    
}
