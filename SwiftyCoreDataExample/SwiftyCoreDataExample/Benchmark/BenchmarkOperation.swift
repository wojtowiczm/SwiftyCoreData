//
//  BanchmarkOperation.swift
//  SwiftyCoreDataExample
//
//  Created by Michał Wójtowicz on 08/01/2019.
//  Copyright © 2019 Michał Wójtowicz. All rights reserved.
//

import Foundation

enum BenchmarkOperation {
    case load
    case delete
    case save
    
    var localizedName: String {
        switch self {
        case .load: return "Load"
        case .delete: return "Delete"
        case .save: return "Save"
        }
    }
}
