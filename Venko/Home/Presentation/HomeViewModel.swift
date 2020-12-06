//
//  HomeViewModel.swift
//  Venko
//
//  Created by Matias Glessi on 06/12/2020.
//  Copyright © 2020 Venko. All rights reserved.
//

import Foundation


class HomeViewModel {
    
    let getTrainee: GetTrainee
    
    init(getTrainee: GetTrainee) {
        self.getTrainee = getTrainee
    }
    
    
    func getTrainee(for dni: String, completionHandler: @escaping (String, Bool) -> Void){
        getTrainee.getTrainee(for: dni, completionHandler: completionHandler)
    }
    
}
