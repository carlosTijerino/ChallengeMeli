//
//  Search.swift
//  ChallengeMeli
//
//  Created by Carlos Raymundo Tijerino Capetillo on 14/04/22.
//

import Foundation

struct Search:Codable {
    
    var site_id: String?
    var query: String?
    var paging:Paging?
    var results:Array<Result>?
    
    //errors
    var message: String?
    var error: String?
    var status: Int?
}
