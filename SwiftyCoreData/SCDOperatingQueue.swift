//
//  SCDOperatigQueue.swift
//  SwiftyCoreData
//
//  Created by Michał Wójtowicz on 08/01/2019.
//  Copyright © 2019 Michał Wójtowicz. All rights reserved.
//

import Foundation

/// OperatingQueue for DataBases operations
///
/// - Cases:
///   - main: Main queue
//    - backgroundQueue: BackgroundQueue
public enum SCDOperatingQueue {
    case main
    case background
}
