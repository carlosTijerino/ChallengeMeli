//
//  Description.swift
//  ChallengeMeli
//
//  Created by Carlos Raymundo Tijerino Capetillo on 14/04/22.
//

import Foundation

struct Description:Codable {
    
    var text: String?
    var plain_text: String?
    var last_updated: String?
    var date_created: String?
    
    //errors
    var message: String?
    var error: String?
    var status: Int?
    
}

