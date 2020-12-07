//
//  ExerciseMapper.swift
//  Venko
//
//  Created by Matias Glessi on 07/12/2020.
//  Copyright © 2020 Venko. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol ExerciseMapper {
    func mapToExercise(json: JSON) -> Exercise
    func mapToWeights(json: JSON) -> [Weights]
    func mapToServerWeights(exercise: Exercise) -> ServerWeights
}

class DefaultExerciseMapper: ExerciseMapper {
    
    func mapToServerWeights(exercise: Exercise) -> ServerWeights {
        var weightsArray = [String]()
        var repsArray = [String]()
        
        for weight in exercise.weights {
            weightsArray.append(weight.first)
            repsArray.append(weight.second)
        }
        
        let weightsString = weightsArray.joined(separator: "-")
        let repsString = repsArray.joined(separator: "-")
       
        return ServerWeights(weights: weightsString, reps: repsString)
    }

    
    func mapToWeights(json: JSON) -> [Weights] {
        var weights = [Weights]()
        let tags = json["fields"]["tags"].stringValue
        
        if tags != "[('0', '0')]" {
            
            let parsedTags = String(tags.dropFirst().dropLast()).replacingOccurrences(of: "u", with: "").replacingOccurrences(of: " ", with: "")
            let arrayOfTuples = parsedTags.replacingOccurrences(of: "'", with: "").replacingOccurrences(of: "),(", with: ");(").split(separator: ";")
            for tuple in arrayOfTuples {
                weights.append(Weights(value: String(tuple)))
            }
        }
        return weights
    }
    
    func mapToExercise(json: JSON) -> Exercise {
        
        let weights = self.mapToWeights(json: json)

        return Exercise(pictureUrl: json["fields"]["video"].stringValue,
                         name: json["fields"]["nombre"].stringValue,
                         youtubeUrl: json["fields"]["url_youtube"].stringValue,
                         tags: json["fields"]["tags"].stringValue,
                         weights: weights,
                         exerciseId: json["pk"].intValue)
    }
    
}
