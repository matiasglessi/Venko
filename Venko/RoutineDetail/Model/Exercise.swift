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
    let pictureUrl: String
    let name: String
    let youtubeUrl: String?
    let tags: String?
    var weights: [Weights]
    let exerciseId: Int
    
    init(pictureUrl: String, name: String, youtubeUrl: String?, tags: String?, weights: [Weights], exerciseId: Int) {
        self.pictureUrl = pictureUrl
        self.name = name
        self.youtubeUrl = youtubeUrl
        self.tags = tags
        self.weights = weights
        self.exerciseId = exerciseId
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
