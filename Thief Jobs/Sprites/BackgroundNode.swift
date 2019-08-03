//
//  BackgroundNode.swift
//  Thief Jobs
//
//  Created by Tibor Alács on 2017. 07. 16..
//  Copyright © 2017. Tibor Alács. All rights reserved.
//

import SpriteKit

public class BackgroundNode : SKNode {
    
    public func setup(size : CGSize) {
        
        let backGround = SKSpriteNode(imageNamed: "landscape_background")
        //let backGround = SKSpriteNode(imageNamed: "bg_\(arc4random_uniform(5)).png)")
        //let backGround = SKSpriteNode(imageNamed: "bg_0")
        
        backGround.size = size
        let yPos : CGFloat =  1 //size.height * 0.10
        let startPoint = CGPoint(x: -5, y: yPos)
        let endPoint = CGPoint(x: size.width, y: yPos)
        backGround.position = CGPoint(x: size.width / 2, y: size.height / 2)
        //backGround.setScale(0.39)
        backGround.zPosition = 1
        //backGround.size = CGSize(width: self.frame.size.width, height: self.frame.size.height)
        
        physicsBody = SKPhysicsBody(edgeFrom: startPoint, to: endPoint)
        physicsBody?.restitution = 0
        physicsBody?.categoryBitMask = PhysicsCategory.WorldCategory
        physicsBody?.collisionBitMask = PhysicsCategory.ThiefCategory
        physicsBody?.contactTestBitMask = PhysicsCategory.ThiefCategory
        backGround.name = "background"
        
        addChild(backGround)
    }
}
