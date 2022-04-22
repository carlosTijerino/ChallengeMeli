//
//  Result.swift
//  ChallengeMeli
//
//  Created by Carlos Raymundo Tijerino Capetillo on 14/04/22.
//

import Foundation

struct Result:Codable {
    
    var id: String?
    var site_id: String?
    var title: String?
    var seller:Seller?
    var price: Double?
    var available_quantity:Int?
    var condition:String?
    var thumbnail:String?
    var accepts_mercadopago:Bool?
    var seller_address:SellerAddress?
    var attributes:Array<Attribute>?
}


