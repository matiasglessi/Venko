//
//  Sound.swift
//  Venko
//
//  Created by Matias Glessi on 24/04/2020.
//  Copyright © 2020 Venko. All rights reserved.
//

import Foundation

struct Sound {
    var showableName: String
    var fileName: String
    var fileExtension: String
    var onlyVoiceSound: Bool = true
    
    init(showableName: String, fileName: String, fileExtension: String, isOnlyVoice: Bool = false) {
        self.showableName = showableName
        self.fileName = fileName
        self.fileExtension = fileExtension
        self.onlyVoiceSound = isOnlyVoice
    }
}

struct CountdownSound {
    var workoutSounds: [Sound]
    var restSounds: [Sound]
}
