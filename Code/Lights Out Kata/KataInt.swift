//
//  KataInt.swift
//  Lights Out Kata
//
//  Created by Robbie Cravens on 7/3/17.
//  Copyright © 2017 Robbie Cravens. All rights reserved.
//

import Foundation

extension Int {
    
    func bitIsOn(_ index: Int) -> Bool {
        return (self >> index) & 1 == 1
    }
}
