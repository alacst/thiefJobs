//
//  GameOver.swift
//  Thief Jobs
//
//  Created by macMini on 2019. 04. 08..
//  Copyright © 2019. Tibor Alács. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameOver: GKState {
    unowned let scene: GameScene
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    
}
