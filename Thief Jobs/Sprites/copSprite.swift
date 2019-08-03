//
//  copSprite.swift
//  Thief Jobs
//
//  Created by Tibor Alács on 2019. 03. 02..
//  Copyright © 2019. Tibor Alács. All rights reserved.
//

import SpriteKit

public class CopSprite : SKSpriteNode {
    
    private static let runFramesLeft = [
        SKTexture(imageNamed: "cop_1"),
        SKTexture(imageNamed: "cop_2")
    ]
    
    private static let runFramesRight = [
        SKTexture(imageNamed: "cop_3"),
        SKTexture(imageNamed: "cop_4")
    ]
    
    private static let standingFrames = [
        SKTexture(imageNamed: "cop_1"),
        SKTexture(imageNamed: "cop_3")
    ]
    
    private let runLeft = SKAction.animate(with: runFramesLeft, timePerFrame: 0.15)
    private let runRight = SKAction.animate(with: runFramesRight, timePerFrame: 0.15)
    private let standing = SKAction.animate(with: standingFrames, timePerFrame: 1.2)
    
    public var currentAnimation = SKAction()
    
    public static func newInstance(position: CGPoint) -> CopSprite {
        let copSprite = CopSprite(imageNamed: "cop_1")

        let copOffsetX = CGFloat(copSprite.frame.size.width * copSprite.anchorPoint.x)
        let copOffsetY = CGFloat(copSprite.frame.size.height * copSprite.anchorPoint.y)
        let copPath = CGMutablePath()
        copPath.move(to: CGPoint(x: 3 - copOffsetX, y: 0 - copOffsetY))
        copPath.move(to: CGPoint(x: 35 - copOffsetX, y: 0 - copOffsetY))
        copPath.move(to: CGPoint(x: 35 - copOffsetX, y: 68 - copOffsetY))
        copPath.move(to: CGPoint(x: 0 - copOffsetX, y: 68 - copOffsetY))
        copPath.closeSubpath()
        
        copSprite.physicsBody = SKPhysicsBody(circleOfRadius: 15)
        
        copSprite.position = position
        copSprite.name = "cop"
        
        copSprite.physicsBody?.isDynamic = true
        copSprite.physicsBody?.affectedByGravity = false
        copSprite.physicsBody?.allowsRotation = false
        copSprite.zPosition = 30
        
        copSprite.setScale(0.39)
        
        //copSprite.physicsBody?.contactTestBitMask = PhysicsCategory.ThiefCategory
        copSprite.physicsBody?.categoryBitMask = PhysicsCategory.CopCategory
        copSprite.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        return copSprite
    }
    
    public func move(p1: CGPoint, p2: CGPoint){
        
        var animate = SKAction()
        let randomTime = Double(CGFloat.random(min: 0.5, max: 1.7))
        let speed : CGFloat = 60
        let randomPoint = CGPoint(x: CGFloat.random(min: p1.x, max: p2.x), y: p1.y)
        let distance = abs(self.position.x - randomPoint.x)
        
        if randomPoint.x < self.position.x {
            
            animate = SKAction.run(animateLeft)
            
        } else {
            
            animate = SKAction.run(animateRight)
            
        }
        
        let moveBy = SKAction.move(to: randomPoint, duration: Double(distance/speed))
        let moveGroup = SKAction.group([moveBy, animate])
        
        let wait = SKAction.wait(forDuration: randomTime)
        let waitAnimate = SKAction.run(animateStand)
        let waitGroup = SKAction.group([wait, waitAnimate])
        
        let moveAgain = SKAction.run({self.move(p1: p1, p2: p2)})
        
        run(SKAction.sequence([moveGroup, waitGroup, moveAgain]))
        
    }
    
    public func animateLeft(){
        let animate = SKAction.repeatForever(runLeft)
        if currentAnimation != runLeft {
            self.removeAction(forKey: "animation")
            self.run(animate, withKey: "animation")
            self.currentAnimation = runLeft
        }
    }
    
    public func animateRight(){
        let animate = SKAction.repeatForever(runRight)
        if currentAnimation != runRight {
            self.removeAction(forKey: "animation")
            self.run(animate, withKey: "animation")
            self.currentAnimation = runRight
        }
    }
    
    public func animateStand(){
        let animate = SKAction.repeatForever(standing)
        if currentAnimation != standing {
            self.removeAction(forKey: "animation")
            self.run(animate, withKey: "animation")
            self.currentAnimation = standing
        }
    }
    
}
