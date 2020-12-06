//
//  RoutineDetailViewModel.swift
//  Venko
//
//  Created by Matias Glessi on 06/12/2020.
//  Copyright © 2020 Venko. All rights reserved.
//

import Foundation

class RoutineDetailViewModel {

    let getExercises: GetExercises
    
    init(getExercises: GetExercises) {
        self.getExercises = getExercises
    }
    
    func getExercises(for routine: Int, completionHandler: @escaping ([Exercise], Bool) -> Void) {
        getExercises.getExercises(for: routine, completionHandler: completionHandler)
    }
}
