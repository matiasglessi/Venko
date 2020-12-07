//
//  GetExercisesAPI.swift
//  Venko
//
//  Created by Matias Glessi on 06/12/2020.
//  Copyright © 2020 Venko. All rights reserved.
//

import Alamofire
import SwiftyJSON

protocol GetExercises {
    func getExercises(for routine: Int, completionHandler: @escaping ([Exercise], Bool) -> Void)
}

class GetExercisesAPI: GetExercises {
    
    let mapper: ExerciseMapper
    
    init(mapper: ExerciseMapper) {
        self.mapper = mapper
    }
    
    
    func getExercises(for routine: Int, completionHandler: @escaping ([Exercise], Bool) -> Void){

        
        Alamofire.request(APIConstants().BASE_URL + APIConstants().GET_RUTINA_MOBILE + String(routine) + APIConstants().TIPO_RUTINA).responseJSON { [weak self] response in
            
            if let value = response.result.value {
                let jsonFields = JSON(value)
                let jsonFieldsArray = jsonFields.arrayValue
                var exercises = [Exercise]()
                for jsonExercise in jsonFieldsArray {
                    if let exercise = self?.mapper.map(json: jsonExercise) {
                        exercises.append(exercise)
                    }
                }
                completionHandler(exercises, false)
                return

            }
            completionHandler([], true)

        }
    }
}
