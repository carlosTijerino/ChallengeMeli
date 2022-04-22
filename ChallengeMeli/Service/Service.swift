//
//  Service.swift
//  ChallengeMeli
//
//  Created by Carlos Raymundo Tijerino Capetillo on 14/04/22.
//

/**Archivo swift para la conexión al servicio web APIS **/

/*
 METHOD
 get_rest_api ** Realiza la petición al servicio con los parámetros recibidos, regresa la respuesta por completion Block.
 
 PARAMETERS
 requestType ** String ** requerido ** El método que hará la petición **ej. GET, POST, etc.
 
 url ** String ** requerido ** La URL del servicio al cual se hará la petición ** ej. https://api.mercadolibre.com/sites/MLA/search?q=
 
 RETURN
 response ** Contiene la respuesta de la petición.
 
 error ** Contiene el error al enviar la petición, en caso de que suceda.
 */

import Foundation

class Service: NSObject {

    var response:String = ""

    //MARK: - Funcion get_rest_api

    func get_rest_api(requestType:String, url:String,completionBlock: @escaping (String,String) -> Void) -> Void{
        
        let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

        let objetoUrl = URL(string:urlString)
                
        let tarea = URLSession.shared.dataTask(with: objetoUrl!) { (datos, respuesta, error) in
            
            if error != nil {
                
                print(error!)
                completionBlock("",error!.localizedDescription)
                
            }
            
            else {
                
                do{
                    self.response = String(data: datos!, encoding: .utf8)!
                    completionBlock(self.response,"")
                }
                
            }
            
        }
        
        tarea.resume()
    }
}




