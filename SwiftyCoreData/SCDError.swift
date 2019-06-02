//
//  SCDError.swift
//  SwiftyCoreData
//
//  Created by Michał Wójtowicz on 02/06/2019.
//  Copyright © 2019 Michał Wójtowicz. All rights reserved.
//

import Foundation

struct SCDError: Error {
    
    let localizedDescription: String
    
    init(_ description: String) {
        self.localizedDescription = description
    }
}
