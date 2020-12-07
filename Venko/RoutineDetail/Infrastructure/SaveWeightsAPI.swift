//
//  SaveWeightsAPI.swift
//  Venko
//
//  Created by Matias Glessi on 06/12/2020.
//  Copyright © 2020 Venko. All rights reserved.
//

import Alamofire

protocol SaveWeights {
    func save(exercise: Exercise, routineId: Int, completionHandler: @escaping (Bool) -> Void)
}

class SaveWeightsAPI: SaveWeights {
    
    let mapper: ExerciseMapper
    
    init(mapper: ExerciseMapper) {
        self.mapper = mapper
    }
    
    func save(exercise: Exercise, routineId: Int, completionHandler: @escaping (Bool) -> Void) {
        
        let weights = mapper.mapToServerWeights(exercise: exercise)
        
        let parameters: [String:Any] = ["pesos": weights.weights,
                                        "repeticiones": weights.reps,
                                        "ejercicio_id": exercise.exerciseId,
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


