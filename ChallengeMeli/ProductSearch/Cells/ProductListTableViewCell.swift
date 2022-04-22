//
//  ProductListTableViewCell.swift
//  ChallengeMeli
//
//  Created by Carlos Raymundo Tijerino Capetillo on 13/04/22.
//

import UIKit

class ProductListTableViewCell: UITableViewCell {

    @IBOutlet weak var ivProduct: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    //MARK: -
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    //MARK: -
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }    
}
