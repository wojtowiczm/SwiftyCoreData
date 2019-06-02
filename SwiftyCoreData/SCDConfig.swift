//
//  SCDConfig.swift
//  SwiftyCoreData
//
//  Created by Michał Wójtowicz on 02/06/2019.
//  Copyright © 2019 Michał Wójtowicz. All rights reserved.
//

import Foundation

public class SCDConfig {
    
    var debugMode: Bool = false
    
    static let shared = SCDConfig()
    
    private init() {}
}
