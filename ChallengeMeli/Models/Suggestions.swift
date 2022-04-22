//
//  Suggestions.swift
//  ChallengeMeli
//
//  Created by Carlos Raymundo Tijerino Capetillo on 18/04/22.
//

import Foundation

struct Suggestions:Codable {
    
    var domain_id: String
    var domain_name: String
    var category_id: String
    var category_name: String
    
    
    //errors
    var message: String?
    var error: String?
    
    
    
}
