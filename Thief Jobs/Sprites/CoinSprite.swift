//
//  CoinSprite.swift
//  Thief Jobs
//
//  Created by Tibor Alács on 2019. 03. 18..
//  Copyright © 2019. Tibor Alács. All rights reserved.
//

import Foundation
import SpriteKit

public class CoinSprite : SKSpriteNode {
    
    public static func newInstance(position: CGPoint) -> CoinSprite {
        let coinSprite = CoinSprite(imageNamed: "coin_1")
        
        coinSprite.physicsBody = SKPhysicsBody(circleOfRadius: 12)
        
        coinSprite.physicsBody?.isDynamic = false
        coinSprite.physicsBody?.affectedByGravity = false
        
        coinSprite.setScale(0.5)
        coinSprite.position = position
        coinSprite.zPosition = 30
        
        coinSprite.physicsBody?.categoryBitMask = PhysicsCategory.CoinCategory
        
        return coinSprite
        
    }
    
    
    
    
}
