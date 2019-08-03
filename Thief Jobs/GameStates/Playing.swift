//
//  Playing.swift
//  Thief Jobs
//
//  Created by macMini on 2019. 04. 08..
//  Copyright © 2019. Tibor Alács. All rights reserved.
//

import SpriteKit
import GameplayKit

class Playing: GKState {
    unowned let scene: GameScene
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        if previousState is WaitingForTap {
            scene.scrollingClouds?.scroll()
            scene.scrollingMountains?.scroll()
            scene.scrollingTrees1?.scroll()
            scene.scrollingTrees2?.scroll()
            scene.scrollingTrees3?.scroll()
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
        scene.scrollWorld()
        
        //assert(1.45 < 1.83)
        //let spawnTime = CGFloat.random() * (1.83 - 1.45) + 1.45
        //print(spawnTime)
        //let dt = currentTime - self.lastUpdateTime
        
        //        if dt > ( Double(spawnTime) ) {
        scene.spawnBuilding()
        scene.removeObjects()
        //removeCop()
        //removeCoin()
        
        if(scene.thiefNode.physicsBody?.velocity.dy ?? 0 > 580) {
            scene.thiefNode.physicsBody?.velocity.dy = 580
        }
        
        //addCoptoScene(distance: buildingNode.frame.size.width, position: CGPoint(x: buildingNode.position.x, y: buildingNode.position.y + buildingNode.frame.size.height / 2 + 12))
        //print(buildingNode.getWidth())
        //            self.lastUpdateTime = currentTime
        //        }
        //also 1.3
        //felso 1.9
        
        
        
        //MARK jo
        //        if ( dt > ( 4.5 - ( 0.9 + drand48() + drand48() * Double(arc4random_uniform(2)) + drand48() * Double(arc4random_uniform(2)) ) ) ){
        //            spawnBuilding()
        //
        //            self.lastUpdateTime = currentTime
        //        }
        
        let position = CGPoint(x: scene.frame.size.width / 4, y: scene.frame.size.height / 2)
        scene.thiefNode.update(position: position)
        
        if (scene.thiefNode.position.x != scene.self.frame.size.width / 4) {
            scene.gameOver()
        }
        
        if(scene.isThiefOnTheGround) {
            jumpFrameCounter = maxJumpFrames
        }
        
        if(scene.screenTouched){
            if(scene.isThiefOnTheGround){
                scene.thiefNode.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 33))
                //thiefNode.physicsBody?.velocity.dy = jumpForce
                scene.stoppedJumping = false
                //print("stoppedjumping: \(stoppedJumping)")
            }
        }
        
        if(scene.screenTouched && !scene.stoppedJumping){
            if(jumpFrameCounter > 0){
                //thiefNode.physicsBody?.applyImpulse(CGVector(dx: 0, dy: jumpForce))
                scene.thiefNode.physicsBody?.applyForce(CGVector(dx: 0, dy: jumpForce * jumpFrameCounter))
                jumpFrameCounter -= 1
                
            }
        }
        
        scene.alertArea.position = scene.thiefNode.position //CGPoint(x: thiefNode.position.x, y: thiefNode.position.y)
        
        scene.spawnTimer += fixedDelta
        
        //cameraNode.position = thiefNode.position
        

    }
}
