//
//  GetTraineeAPI.swift
//  Venko
//
//  Created by Matias Glessi on 06/12/2020.
//  Copyright © 2020 Venko. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

protocol GetTrainee {
    func getTrainee(for dni: String, completionHandler: @escaping (String, Bool) -> Void)
}

class GetTraineeAPI: GetTrainee {
    
    func getTrainee(for dni: String, completionHandler: @escaping (String, Bool) -> Void){
        Alamofire.request(APIConstants().BASE_URL + APIConstants().LOGIN + dni).responseJSON { response in
            
            if let value = response.result.value {
                let jsonFields = JSON(value)
                let jsonFieldsArray = jsonFields.arrayValue
                if let first = jsonFieldsArray.first, let name = first["fields"]["nombre"].string {
                    completionHandler(name, false)
                    return
                }
            }
            completionHandler("", true)

        }
    }
}
