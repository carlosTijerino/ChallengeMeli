//
//  SellerAddress.swift
//  ChallengeMeli
//
//  Created by Carlos Raymundo Tijerino Capetillo on 14/04/22.
//

import Foundation

struct SellerAddress:Codable {
    
    var id: String?
    var comment: String?
    var address_line: String?
    var zip_code: String?
    var country:Country?
    var state:State?
}
