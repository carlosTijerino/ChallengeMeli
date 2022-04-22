//
//  Constants.swift
//  ChallengeMeli
//
//  Created by Carlos Raymundo Tijerino Capetillo on 14/04/22.
//

/*Archivo swift para declaración de constantes en el proyecto
 como url a APIS*/

import Foundation

struct Constants {
    
    //API de mercado libre
    static let apiMELI = "https://api.mercadolibre.com"
    
    //Obtener ítems de una consulta de búsqueda
    static let searchItems = "/sites/MLA/search?q="
    
    //Obtener ítems de vendedor por id del vendedor
    static let searchItemsSeller = "/sites/MLA/search?seller_id="
    
    //Obtener el detalle de un ítem
    static let items = "/items/"

    //obtener sugerencias de categorioas
    static let domain_discovery = "/sites/MLA/domain_discovery/search?"
}

