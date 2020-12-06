//
//  RoutineMapper.swift
//  Venko
//
//  Created by Matias Glessi on 06/12/2020.
//  Copyright © 2020 Venko. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol RoutineMapper {
    func map(json: JSON) -> Routine
}

class DefaultRoutineMapper: RoutineMapper {
    
    func map(json: JSON) -> Routine {
        return Routine(ocurrences: json["CantDeOcurrencias"].intValue,
                        pictureUrl: json["foto"].stringValue,
                        routineId: json["id"].intValue,
                        name: json["nombre"].stringValue,
                        youtubeUrl: json["url_youtube"].stringValue)
    }
    
}
