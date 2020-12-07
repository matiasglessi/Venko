//
//  Weights.swift
//  Venko
//
//  Created by Matias Glessi on 06/12/2020.
//  Copyright © 2020 Venko. All rights reserved.
//

import Foundation

class Weights {
    
    var first: String = ""
    var second: String = ""
    
    init(first: String, second: String) {
        self.first = first
        self.second = second
    }
    
    init(value: String) {
        let elements = String(value.dropFirst().dropLast()).components(separatedBy: ",")
        if elements.count == 2 {
            self.first = elements[0]
            self.second = elements[1]
        }
    }
    
}

struct ServerWeights {
     
    var weights = ""
    var reps = ""
}
