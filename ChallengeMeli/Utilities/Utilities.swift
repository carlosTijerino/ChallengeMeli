//
//  Utilities.swift
//  ChallengeMeli
//
//  Created by Carlos Raymundo Tijerino Capetillo on 19/04/22.
//

import UIKit

class Utilities: NSObject {
    
    //MARK: -
    
    /*Función formatString para formatear los montos con separator de miles y decimales
    
     PARAMETERS
     amount ** Double ** Requerido ** el monto para formatear con separador de miles y decimales
     
     RETURN
     formattedString ** String ** El valor formateado de la cantidad recibida*/
    
    func formatString(amount:Double)-> String{
        
        let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.locale = Locale.current

        let formattedString = formatter.string(for: amount)
        
        return formattedString ?? "0"
        
    }

    //MARK: -
    
}
