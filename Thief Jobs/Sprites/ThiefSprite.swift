//
//  ThiefSprite.swift
//  Thief Jobs
//
//  Created by Tibor Alács on 2017. 07. 16..
//  Copyright © 2017. Tibor Alács. All rights reserved.
//

import SpriteKit

public class ThiefSprite : SKSpriteNode {
    
    private let runningActionKey = "running"
    private let jumpingActionKey = "jumping"
    
    
    private let runFrames = [
        SKTexture(imageNamed: "thief_1"),
        SKTexture(imageNamed: "thief_2")
    ]    
    
    public static func newInstance(position: CGPoint) -> ThiefSprite {
        let thiefSprite = ThiefSprite(imageNamed: "thief_1")
       
        //path for the physics body
        let thiefOffsetX = CGFloat(thiefSprite.frame.size.width * thiefSprite.anchorPoint.x)
        let thiefOffsetY = CGFloat(thiefSprite.frame.size.height * thiefSprite.anchorPoint.y)
        let thiefPath = CGMutablePath()
        thiefPath.move(to: CGPoint(x: 3 - thiefOffsetX, y: 0 -  thiefOffsetY))
        thiefPath.addLine(to: CGPoint(x: 35 - thiefOffsetX, y: 0 - thiefOffsetY))
        thiefPath.addLine(to: CGPoint(x: 35 - thiefOffsetX, y: 68 - thiefOffsetY))
        thiefPath.addLine(to: CGPoint(x: 0 - thiefOffsetX, y: 68 - thiefOffsetY))
        thiefPath.closeSubpath()
        thiefSprite.physicsBody = SKPhysicsBody(polygonFrom: thiefPath)
        thiefSprite.name = "thief"
        
        thiefSprite.physicsBody?.categoryBitMask = PhysicsCategory.ThiefCategory
        thiefSprite.physicsBody?.collisionBitMask = PhysicsCategory.BuildingCategory | PhysicsCategory.CopCategory | PhysicsCategory.WorldCategory
        thiefSprite.physicsBody?.contactTestBitMask = PhysicsCategory.WorldCategory | PhysicsCategory.CoinCategory
        
        thiefSprite.physicsBody?.isDynamic = true
        thiefSprite.physicsBody?.affectedByGravity = true
        thiefSprite.physicsBody?.allowsRotation = false
        thiefSprite.position = position
        thiefSprite.zPosition = 30
        thiefSprite.physicsBody?.density = 0.9
        thiefSprite.physicsBody?.friction = 0.0
        thiefSprite.physicsBody?.restitution = 0.0
        thiefSprite.setScale(0.39)
        
        return thiefSprite
    }
    
    public func update(position: CGPoint){
        if action(forKey: runningActionKey) == nil {
            let runningAction = SKAction.repeatForever(SKAction.animate(with:runFrames, timePerFrame: 0.11, resize: false, restore: true))

            run(runningAction, withKey: runningActionKey)

        }

    }
    
}
