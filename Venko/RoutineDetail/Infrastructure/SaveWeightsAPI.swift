//
//  SaveWeightsAPI.swift
//  Venko
//
//  Created by Matias Glessi on 06/12/2020.
//  Copyright © 2020 Venko. All rights reserved.
//

import Alamofire



protocol SaveWeights {
    
}

class SaveWeightsAPI: SaveWeights {
    
    func save(weights: WeightsToGo, exerciseId: Int, routineId: Int, completionHandler: @escaping (Bool) -> Void) {
        let parameters: [String:Any] = ["pesos": weights.weights,
                                        "repeticiones": weights.reps,
                                        "ejercicio_id": exerciseId,
                                        "rutina": routineId]
        do {
         let parametersStringified = try JSONStringify(value: parameters).stringify()

            Alamofire.request(APIConstants().BASE_URL +  APIConstants().SAVE_CURRENT_WEIGHTS, method: .post, parameters: [:], encoding: JSONStringArrayEncoding.init(string: parametersStringified), headers: [:]).responseJSON { (response) in
                completionHandler(false)
            }
        } catch _ {
            completionHandler(true)
        }
    }
}
