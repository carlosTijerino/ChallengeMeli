//
//  ItemsSeller.swift
//  ChallengeMeli
//
//  Created by Carlos Raymundo Tijerino Capetillo on 15/04/22.
//

import Foundation


struct ItemsSeller:Codable {
    
    var results:Array<Result>?
    
    //errors
    var message: String?
    var error: String?
    var status: Int?
    
}
