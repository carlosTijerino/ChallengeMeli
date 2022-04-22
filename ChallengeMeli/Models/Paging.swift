//
//  Paging.swift
//  ChallengeMeli
//
//  Created by Carlos Raymundo Tijerino Capetillo on 14/04/22.
//

import Foundation

struct Paging:Codable {
   
    var total: Int?
    var primary_results: Int?
    var offset:Int?
    var limit:Int?
}
