//
//  PhysicsCategories.swift
//  Bug Game
//
//  Created by Jonas Haag on 2017-10-12.
//  Copyright © 2017 Jonas Haag. All rights reserved.
//

import Foundation

struct PhysicsCategories {
    static let Player : UInt32 = 0x1 << 0
    static let Obstacle : UInt32 = 0x1 << 1
    static let Enemy : UInt32 = 0x1 << 2
    static let Spitball : UInt32 = 0x1 << 3
}
