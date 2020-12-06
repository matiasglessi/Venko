//
//  Routine.swift
//  Venko
//
//  Created by Matias Glessi on 19/03/2020.
//  Copyright © 2020 Venko. All rights reserved.
//

import Foundation
import SwiftyJSON

class Routine {
    
    var ocurrences: Int = 0
    var pictureUrl: String = ""
    var routineId: Int = 0
    var name: String = ""
    var youtubeUrl: String?
    
    init?(json: JSON) {
        self.routineId = json["id"].intValue
        self.pictureUrl = json["foto"].stringValue
        self.youtubeUrl = json["url_youtube"].stringValue
        self.name = json["nombre"].stringValue
        self.ocurrences = json["CantDeOcurrencias"].intValue
    }
        
}
