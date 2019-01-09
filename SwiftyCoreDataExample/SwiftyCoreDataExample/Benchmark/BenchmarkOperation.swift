//
//  BanchmarkOperation.swift
//  SwiftyCoreDataExample
//
//  Created by Michał Wójtowicz on 08/01/2019.
//  Copyright © 2019 Michał Wójtowicz. All rights reserved.
//

import Foundation

enum BenchmarkOperation {
    case read
    case delete
    case write
    
    var localizedName: String {
        switch self {
        case .read: return "Read"
        case .delete: return "Delete"
        case .write: return "Write"
        }
    }
}
