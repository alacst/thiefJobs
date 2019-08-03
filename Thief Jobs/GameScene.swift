//
//  GameScene.swift
//  Thief Jobs
//
//  Created by Tibor Alács on 2017. 07. 06..
//  Copyright © 2017. Tibor Alács. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    public var lastUpdateTime : TimeInterval = 0
    public var spawnTimer : CFTimeInterval = 0
    
    public var scrollingGameObjects = SKNode()
    
    public let backgroundNode = BackgroundNode()
    public var thiefNode : ThiefSprite!
    public var buildingNode = BuildingSprite()
    public var copNode : CopSprite!
    public var coinNode : SKSpriteNode!
    public var alertArea = SKSpriteNode()
   
    public var isFirstBuilding : Bool = true
    
    public var isThiefOnTheGround : Bool = true
    public var stoppedJumping : Bool = true
    public var screenTouched : Bool = false
    
    public var scrollingClouds : InfiniteScrollingBackground?
    public var scrollingMountains : InfiniteScrollingBackground?
    public var scrollingTrees1 : InfiniteScrollingBackground?
    public var scrollingTrees2 : InfiniteScrollingBackground?
    public var scrollingTrees3 : InfiniteScrollingBackground?
    
    public let cameraNode = SKCameraNode()
    
    public lazy var gameState: GKStateMachine = GKStateMachine(states:[
        WaitingForTap(scene: self),
        Playing(scene: self),
        GameOver(scene: self)])
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        let clouds = [
            UIImage(named: "landscape_clouds")!,
            UIImage(named: "landscape_clouds")!
        ]
        
        let mountains = [
            UIImage(named: "landscape_mountain")!,
            UIImage(named: "landscape_mountain")!
        ]
        
        let trees1 = [
            UIImage(named: "landscape_1_trees")!,
            UIImage(named: "landscape_1_trees")!
        ]
        
        let trees2 = [
            UIImage(named: "landscape_2_trees")!,
            UIImage(named: "landscape_2_trees")!
        ]
        
        let trees3 = [
            UIImage(named: "landscape_3_trees")!,
            UIImage(named: "landscape_3_trees")!
        ]
        
        scrollingClouds = InfiniteScrollingBackground(images: clouds, scene: self, scrollDirection: .left, transitionSpeed: 0.7)
        scrollingClouds?.zPosition = 2
        //scrollingClouds?.scroll()
        
        scrollingMountains = InfiniteScrollingBackground(images: mountains, scene: self, scrollDirection: .left, transitionSpeed: 0.9)
        scrollingMountains?.zPosition = 3
        //scrollingMountains?.scroll()
        
        scrollingTrees1 = InfiniteScrollingBackground(images: trees1, scene: self, scrollDirection: .left, transitionSpeed: 2.1)
        scrollingTrees1?.zPosition = 6
        //scrollingTrees1?.scroll()

        scrollingTrees2 = InfiniteScrollingBackground(images: trees2, scene: self, scrollDirection: .left, transitionSpeed: 1.7)
        scrollingTrees2?.zPosition = 5
        //scrollingTrees2?.scroll()

        scrollingTrees3 = InfiniteScrollingBackground(images: trees3, scene: self, scrollDirection: .left, transitionSpeed: 1.3)
        scrollingTrees3?.zPosition = 4
        //scrollingTrees3?.scroll()
        
        gameState.enter(WaitingForTap.self)
        
    }
    
    override func sceneDidLoad() {
        
        addChild(scrollingGameObjects)
        
        backgroundNode.setup(size: size)
        addChild(backgroundNode)
        
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -11)
        self.physicsWorld.contactDelegate = self
        
        addThiefToScene()
        spawnBuilding()
        
        
        
        //addCoptoScene(distance: 40, position: CGPoint(x: 500, y: 100))
        
        
//        addChild(cameraNode)
//        camera = cameraNode
//        cameraNode.position = thiefNode.position
//        cameraNode.yScale = 3
//        cameraNode.xScale = 3
//
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let other = contact.bodyA.categoryBitMask == PhysicsCategory.ThiefCategory ? contact.bodyB : contact.bodyA
        switch other.categoryBitMask {
        
        case PhysicsCategory.BuildingCategory:
            isThiefOnTheGround = true
        
        case PhysicsCategory.CoinCategory:
            if let coin = other.node as? SKSpriteNode {
                coin.removeFromParent()
            }
            
        case PhysicsCategory.WorldCategory:
            gameOver()
            
        default:
            break
        }
        
        
        
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if (collision == PhysicsCategory.BuildingCategory | PhysicsCategory.ThiefCategory) {
            isThiefOnTheGround = false
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        switch gameState.currentState {
            
        case is WaitingForTap:
            gameState.enter(Playing.self)
            
        case is Playing:
            self.screenTouched = true
            
        case is GameOver:
            let newScene:GameScene = GameScene(size: self.view!.bounds.size)
            let transition = SKTransition.fade(withDuration: 0.5)
            newScene.scaleMode = SKSceneScaleMode.aspectFill
            self.view!.presentScene(newScene, transition: transition)
            
        default:
            break
        }
        
        

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        self.screenTouched = false
        
        thiefNode.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -12))
        
        jumpFrameCounter = 0
        stoppedJumping = true
        
//        //button
//        for touch: AnyObject in touches {
//            // Get the location of the touch in this scene
//            let location = touch.location(self)
//            // Check if the location of the touch is within the button's bounds
//            if button.containsPoint(location) {
//                println("tapped!")
//            }
//        }

    }
    
    func scrollWorld() {
        scrollingGameObjects.position.x -= scrollingSpeed * CGFloat(fixedDelta)
    }
    
    public static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        assert(min < max)
        return CGFloat.random() * (max - min) + min
    }
    
    
    func addCoptoScene(position: CGPoint){
        
        copNode = CopSprite.newInstance(position: position)
        scrollingGameObjects.addChild(copNode)
        
    }
    
    
    func addThiefToScene(){
        if let currentThief = thiefNode, children.contains(currentThief){
            thiefNode.removeFromParent()
            thiefNode.removeAllActions()
            thiefNode.physicsBody = nil
        }
        
        //let position = CGPoint(x: 0, y: 0)
        let position = CGPoint(x: self.frame.size.width / 4, y: self.frame.size.height / 2)
        thiefNode = ThiefSprite.newInstance(position: position)
        //print(CGPoint(x: self.frame.width / 3, y: self.frame.height / 3))
        addAlertArea()
        addChild(thiefNode)
    }
    
    
    public func spawnBuilding() {
       
        if(isFirstBuilding){
            buildingNode = BuildingSprite.createFirst()
            
            scrollingGameObjects.addChild(buildingNode)
            
            buildingNode = BuildingSprite.newInstance()
            assert(340.0 < 515.0)
            let randomY = CGFloat.random() * (515.0 - 340.0) + 340.0
            let position = CGPoint(x: 550, y: -randomY )
            buildingNode.position = self.convert(position, to: scrollingGameObjects)
            
            scrollingGameObjects.addChild(buildingNode)
            
            buildingNode = BuildingSprite.newInstance()
            assert(340.0 < 515.0)
            let randomY2 = CGFloat.random() * (515.0 - 340.0) + 340.0
            let position2 = CGPoint(x: 950, y: -randomY2 )
            buildingNode.position = self.convert(position2, to: scrollingGameObjects)
            spawnRandom(building: buildingNode)
            
            scrollingGameObjects.addChild(buildingNode)
            
            
            
            isFirstBuilding = false
            
        } else {
            if spawnTimer >= ( Double(CGFloat.random() * (1.83 - 1.57) + 1.57) ) {
        
                buildingNode = BuildingSprite.newInstance()
                
                assert(340.0 < 515.0)
                let randomY = CGFloat.random() * (515.0 - 340.0) + 340.0
                let position = CGPoint(x: size.width + 250 , y: -randomY )
                buildingNode.position = self.convert(position, to: scrollingGameObjects)
                
                
                spawnRandom(building: buildingNode)

                
                scrollingGameObjects.addChild(buildingNode)
                
                spawnTimer = 0
        
            }
        }
        
        }
    
    public func spawnRandom(building: BuildingSprite){
        
        let spawnPercentage = 90
        
        if Int.random(min: 1, max: 100) <= spawnPercentage {
            //spawn cops at 20%
            if Int.random(min: 1, max: 100) <= 20 {
                addCoptoScene(position: CGPoint(x: building.position.x, y: building.position.y + building.frame.size.height / 2 + 12))
                let p1x = building.position.x - CGFloat(building.getWidth()) / 2 // + 15
                let   y = building.position.y + CGFloat(building.frame.size.height) / 2 + 12
                let p2x = building.position.x + CGFloat(building.getWidth()) / 2 // - 15
                
                copNode.move(p1: CGPoint(x: p1x, y: y), p2: CGPoint(x: p2x, y: y))
                
            } else {
                //addCointoScene(point: CGPoint(x: point.x, y: point.y + size.height / 2 + 12))
                addCointoScene(point: CGPoint(x: building.position.x, y: building.position.y + building.frame.size.height / 2 + 12))
            }
        }
    }
    
    func gameOver(){
        gameState.enter(GameOver.self)
        let overlay = SKSpriteNode(imageNamed: "overlay")
        let button = SKSpriteNode(imageNamed: "restartButton")
        overlay.zPosition = 50
        overlay.setScale(0.4)
        overlay.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        button.setScale(0.2)
        button.position = CGPoint(x: 0, y: -135)
        addChild(overlay)
        overlay.addChild(button)
    }
    
    func addCointoScene(point: CGPoint) {
        
        coinNode = CoinSprite.newInstance(position: point)
        var textures: [SKTexture] = []
        for i in 1...6 {
            textures.append(SKTexture(imageNamed: "coin_\(i)"))
        }
        
        let animate = SKAction.animate(with: textures, timePerFrame: 0.083)
        let animateCoin = SKAction.repeatForever(animate)
        
        coinNode.run(animateCoin)
        
        scrollingGameObjects.addChild(coinNode)
        
    }
    
    public func addAlertArea(){
        
        //alertArea.color = UIColor.blue
        alertArea.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 550, height: 330))
        alertArea.physicsBody?.affectedByGravity = false
        alertArea.physicsBody?.allowsRotation = false
        alertArea.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        alertArea.physicsBody!.categoryBitMask = PhysicsCategory.AlertCategory
        alertArea.physicsBody!.collisionBitMask = PhysicsCategory.none
        
        
        alertArea.position = thiefNode.position
        addChild(alertArea)
    }
    
    func removeObjects() {
        for buildingNode in scrollingGameObjects.children as! [SKSpriteNode] {
        let buildingPosition = scrollingGameObjects.convert(buildingNode.position, to: self)
        if buildingPosition.x <= -350 {
            buildingNode.removeFromParent()
            }
        }
        
    }
    
//    func removeCop() {
//        for copNode in scrollingGameObjects.children as! [SKSpriteNode] {
//            let copPosition = scrollingGameObjects.convert(copNode.position, to: self)
//            if copPosition.x <= -350 {
//                copNode.removeFromParent()
//            }
//        }
//
//    }
//
//    func removeCoin() {
//        for coinNode in scrollingGameObjects.children as! [SKSpriteNode] {
//            let coinPosition = scrollingGameObjects.convert(coinNode.position, to: self)
//            if coinPosition.x <= -350 {
//                coinNode.removeFromParent()
//            }
//        }
//
//    }
    
    
    
    override func update(_ currentTime: TimeInterval){
        
        gameState.update(deltaTime: currentTime)
        
//        if ( self.lastUpdateTime == 0) {
//            self.lastUpdateTime = currentTime
//        }
//
//        scrollWorld()
//
//        //assert(1.45 < 1.83)
//        //let spawnTime = CGFloat.random() * (1.83 - 1.45) + 1.45
//        //print(spawnTime)
//        //let dt = currentTime - self.lastUpdateTime
//
////        if dt > ( Double(spawnTime) ) {
//            spawnBuilding()
//            removeObjects()
//            //removeCop()
//            //removeCoin()
//
//        if(thiefNode.physicsBody?.velocity.dy ?? 0 > 580) {
//            thiefNode.physicsBody?.velocity.dy = 580
//        }
//
//            //addCoptoScene(distance: buildingNode.frame.size.width, position: CGPoint(x: buildingNode.position.x, y: buildingNode.position.y + buildingNode.frame.size.height / 2 + 12))
//            //print(buildingNode.getWidth())
////            self.lastUpdateTime = currentTime
////        }
//        //also 1.3
//        //felso 1.9
//
//
//
//        //MARK jo
////        if ( dt > ( 4.5 - ( 0.9 + drand48() + drand48() * Double(arc4random_uniform(2)) + drand48() * Double(arc4random_uniform(2)) ) ) ){
////            spawnBuilding()
////
////            self.lastUpdateTime = currentTime
////        }
//
//        let position = CGPoint(x: self.frame.size.width / 4, y: self.frame.size.height / 2)
//        thiefNode.update(position: position)
//
//        if(isThiefOnTheGround) {
//            jumpFrameCounter = maxJumpFrames
//        }
//
//        if(screenTouched){
//            if(isThiefOnTheGround){
//                thiefNode.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 33))
//                //thiefNode.physicsBody?.velocity.dy = jumpForce
//                stoppedJumping = false
//                //print("stoppedjumping: \(stoppedJumping)")
//            }
//        }
//
//        if(screenTouched && !stoppedJumping){
//            if(jumpFrameCounter > 0){
//                //thiefNode.physicsBody?.applyImpulse(CGVector(dx: 0, dy: jumpForce))
//                thiefNode.physicsBody?.applyForce(CGVector(dx: 0, dy: jumpForce * jumpFrameCounter))
//                jumpFrameCounter -= 1
//
//            }
//        }
//
//        alertArea.position = thiefNode.position //CGPoint(x: thiefNode.position.x, y: thiefNode.position.y)
//
//        spawnTimer += fixedDelta
//
//        //cameraNode.position = thiefNode.position
//

    }
    
}
