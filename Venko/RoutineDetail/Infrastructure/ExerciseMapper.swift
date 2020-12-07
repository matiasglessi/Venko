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
    func map(json: JSON) -> Exercise
}

class DefaultExerciseMapper: ExerciseMapper {
    
    func map(json: JSON) -> Exercise {
        
        var weights = [Weights]()
        let tags = json["fields"]["tags"].stringValue
        
        if tags != "[('0', '0')]" {
            
            let parsedTags = String(tags.dropFirst().dropLast()).replacingOccurrences(of: "u", with: "").replacingOccurrences(of: " ", with: "")
            let arrayOfTuples = parsedTags.replacingOccurrences(of: "'", with: "").replacingOccurrences(of: "),(", with: ");(").split(separator: ";")
            for tuple in arrayOfTuples {
                weights.append(Weights(value: String(tuple)))
            }
        }
        
        
        return Exercise(pictureUrl: json["fields"]["video"].stringValue,
                         name: json["fields"]["nombre"].stringValue,
                         youtubeUrl: json["fields"]["url_youtube"].stringValue,
                         tags: tags,
                         weights: weights,
                         exerciseId: json["pk"].intValue)
    }
    
}
