//
//  Threadz.swift
//  Threadz
//
//  Created by Justin Honda on 10/8/19.
//  Copyright © 2019 Justin Honda. All rights reserved.
//

import Foundation

class Threadz {
    
    public func performUIAnimation(withDelay delay: DispatchTime?, completion: (Bool) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: delay, qos: .userInitiated, flags: .enforceQoS) {
            
        }
    }
    
}
