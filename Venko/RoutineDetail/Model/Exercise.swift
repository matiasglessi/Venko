//
//  Exercise.swift
//  Venko
//
//  Created by Matias Glessi on 19/03/2020.
//  Copyright © 2020 Venko. All rights reserved.
//

import Foundation
import SwiftyJSON

class Exercise {
    
    var pictureUrl: String = ""
    var name: String = ""
    var youtubeUrl: String?
    var tags: String?
    var weights = [Weights]()
    var exerciseId: Int = 0
    
    init?(json: JSON) {
        self.exerciseId = json["pk"].intValue
        self.pictureUrl = json["fields"]["video"].stringValue
        self.youtubeUrl = json["fields"]["url_youtube"].stringValue
        self.name = json["fields"]["nombre"].stringValue
        
        let tags = json["fields"]["tags"].stringValue
        
        if tags != "[('0', '0')]" {
            
            let parsedTags = String(tags.dropFirst().dropLast()).replacingOccurrences(of: "u", with: "").replacingOccurrences(of: " ", with: "")
            let arrayOfTuples = parsedTags.replacingOccurrences(of: "'", with: "").replacingOccurrences(of: "),(", with: ");(").split(separator: ";")
            for tuple in arrayOfTuples {
                weights.append(Weights(value: String(tuple)))
            }
        }
    }
    
    func generateWeightsForServer() -> WeightsToGo {
    
        var weightsArray = [String]()
        var repsArray = [String]()
        
        for weight in weights {
            weightsArray.append(weight.first)
            repsArray.append(weight.second)
        }
        
        let weightsString = weightsArray.joined(separator: "-")
        let repsString = repsArray.joined(separator: "-")
        
        return WeightsToGo(weights: weightsString, reps: repsString)
    }
}


