//
//  ViewModel.swift
//  SwiftyCoreDataExample
//
//  Created by Michał Wójtowicz on 20/12/2018.
//  Copyright © 2018 Michał Wójtowicz. All rights reserved.
//

import SwiftyCoreData

class ViewModel {
    
    let catsDataBaseWorker = SCDWorker<Cat, CatEntity>(persistanceService: PersistanceService.shared)
    
    func loadCats(completion: ([Cat]) -> Void) {
        catsDataBaseWorker.fetchAllObjects(completion: completion)
    }
}

