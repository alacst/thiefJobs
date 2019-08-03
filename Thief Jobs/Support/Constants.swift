//
//  Constants.swift
//  Thief Jobs
//
//  Created by Tibor Alács on 2017. 07. 16..
//  Copyright © 2017. Tibor Alács. All rights reserved.
//

import Foundation
import SpriteKit

let minJumpImpulse : CGFloat = 90.0
let maxJumpImpulse : CGFloat = 280.0

let scrollingSpeed : CGFloat = 225
let buildingSpeed : TimeInterval = 6.3          //6.3

let fixedDelta: CFTimeInterval = 1.0 / 60.0     //60fps

struct PhysicsCategory {
    static let none             :   UInt32 = 0
    static let WorldCategory    :   UInt32 = 0b1
    static let ThiefCategory    :   UInt32 = 0b10
    static let BuildingCategory :   UInt32 = 0b100
    static let CopCategory      :   UInt32 = 0b1000
    static let CoinCategory     :   UInt32 = 0b10000
    static let AlertCategory    :   UInt32 = 0b100000
}

var jumpForce : Int = 20
var maxJumpFrames : Int = 18        //24
var jumpFrameCounter : Int = 18     //24

