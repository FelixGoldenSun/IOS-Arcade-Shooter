//
//  GameUtils.swift
//  Game jr.
//
//  Created by WALLS BENAJMIN A on 4/12/16.
//  Copyright © 2016 WALLS BENAJMIN A. All rights reserved.
//

import Foundation
import SpriteKit

func degreesToRadians(degrees : CGFloat)->CGFloat{
    return CGFloat(degrees * CGFloat(M_PI) / 180.0)
}

func delay(delay: Double, closure: ()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(),
        closure
    )
}


struct PhysicsCategory {
    static let None : UInt32 = 0
    static let All : UInt32 = UINT32_MAX
    static let Enemy : UInt32 = 0b1 //1
    static let PhaserShot : UInt32 = 0b10 //2
    static let Ship : UInt32 = 0b100 //4
}
