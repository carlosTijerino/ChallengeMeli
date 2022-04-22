//
//  ConnectionManager.swift
//  ChallengeMeli
//
//  Created by Carlos Raymundo Tijerino Capetillo on 15/04/22.
//

/*Clase para verificar la conexión de internet*/

import Foundation

//MARK: - ConnectionManager

class ConnectionManager {

    static let shared = ConnectionManager()
    private init () {}

    //MARK: -hasConnectivity
    
    func hasConnectivity() -> Bool {
        do {
            let reachability: Reachability = try Reachability()
            let networkStatus = reachability.connection
            
            switch networkStatus {
            case .unavailable:
                return false
            case .wifi, .cellular:
                return true
            }
        }
        catch {
            return false
        }
    }
}
