//
//  WriteTests.swift
//  SwiftyCoreDataTests
//
//  Created by KISS digital on 21/06/2019.
//  Copyright © 2019 Michał Wójtowicz. All rights reserved.
//


import XCTest

@testable import SwiftyCoreData

class WritingTests: XCTestCase {
    
    var controller: SCDController<TestModel, TestManagedObject>?
    
    override func setUp() {
        controller = SCDController<TestModel, TestManagedObject>(with: TestPersistanceService.shared.container, operatingQueue: .background)
    }
    
}
