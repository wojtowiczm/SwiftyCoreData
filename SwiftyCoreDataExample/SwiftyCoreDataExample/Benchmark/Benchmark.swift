//
//  Benchmark.swift
//  SwiftyCoreDataExample
//
//  Created by Michał Wójtowicz on 09/01/2019.
//  Copyright © 2019 Michał Wójtowicz. All rights reserved.
//

import Foundation
import SwiftyCoreData
import CoreData

protocol Benchmark {
    func prepare()
    func operate()
    func operateOldWay()
    func finalize()
}
