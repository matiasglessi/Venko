//
//  ExerciseViewModel.swift
//  Venko
//
//  Created by Matias Glessi on 07/12/2020.
//  Copyright © 2020 Venko. All rights reserved.
//

import Foundation

class ExerciseViewModel {
    
    let saveWeights: SaveWeights
    
    init(saveWeights: SaveWeights) {
        self.saveWeights = saveWeights
    }
    
    func save(exercise: Exercise, routineId: Int, completionHandler: @escaping (Bool) -> Void) {
        
        let weights = exercise.generateWeightsForServer()
        
        saveWeights.save(weights: weights, exerciseId: exercise.exerciseId, routineId: routineId, completionHandler: completionHandler)
    }
}
