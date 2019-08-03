//
//  BuildingSprite.swift
//  Thief Jobs
//
//  Created by Tibor Alács on 2017. 07. 19..
//  Copyright © 2017. Tibor Alács. All rights reserved.
//

import SpriteKit

public class BuildingSprite : SKSpriteNode {
    
    public static var buildingCount : Int = 0
    
    public static func newInstance() -> BuildingSprite{
        
        let buildingTexture = SKTexture(imageNamed: "sks_0_\(arc4random_uniform(8))")
        
        let buildingSprite = BuildingSprite(texture: buildingTexture)
        
        buildingSprite.zPosition = 20
        
        buildingSprite.physicsBody = SKPhysicsBody(texture: buildingTexture, size: CGSize(width: buildingSprite.size.width, height: buildingSprite.size.height))
        buildingSprite.physicsBody?.friction = 0.0
        buildingSprite.physicsBody?.restitution = 0.0
        buildingSprite.physicsBody?.isDynamic = false
        buildingSprite.physicsBody?.affectedByGravity = false
        buildingSprite.setScale(1.7)
        buildingSprite.name = "building"
        buildingCount += 1
        buildingSprite.physicsBody?.contactTestBitMask = PhysicsCategory.ThiefCategory
        buildingSprite.physicsBody?.categoryBitMask = PhysicsCategory.BuildingCategory

        return buildingSprite
        
    }
    
    public static func createFirst() -> BuildingSprite {
        
        let firstBuilding = BuildingSprite(imageNamed: "firstBuilding")

        let offsetX : CGFloat = firstBuilding.frame.size.width * firstBuilding.anchorPoint.x
        let offsetY : CGFloat = firstBuilding.frame.size.height * firstBuilding.anchorPoint.y
        let firstBuildingPath = CGMutablePath()
        firstBuildingPath.move(to: CGPoint(x: 40 - offsetX, y: 515 - offsetY))
        firstBuildingPath.addLine(to: CGPoint(x: 242 - offsetX, y: 515 - offsetY))
        firstBuildingPath.addLine(to: CGPoint(x: 242 - offsetX, y: 480 - offsetY))
        firstBuildingPath.addLine(to: CGPoint(x: 40 - offsetX, y: 480 - offsetY))
        firstBuildingPath.closeSubpath()
        firstBuilding.physicsBody = SKPhysicsBody(polygonFrom: firstBuildingPath)
        
        firstBuilding.physicsBody?.friction = 0.0
        firstBuilding.physicsBody?.restitution = 0.0
        firstBuilding.physicsBody?.isDynamic = false
        firstBuilding.physicsBody?.affectedByGravity = false
        firstBuilding.physicsBody?.contactTestBitMask = PhysicsCategory.ThiefCategory
        firstBuilding.physicsBody?.categoryBitMask = PhysicsCategory.BuildingCategory
        
        firstBuilding.position = CGPoint(x: 220, y: -3)
        firstBuilding.zPosition = 20
        
        return firstBuilding
        
    }
    
    public func getWidth() -> Int{
        switch self.texture!.name {
        case "sks_0_0":
            return  150 //98
        case "sks_0_1":
            return 168 //108
        case "sks_0_2":
            return 175 //115
        case "sks_0_3":
            return 245 //156
        case "sks_0_4":
            return 160 //108
        case "sks_0_5":
            return 135 //92
        case "sks_0_6":
            return 245 //158
        case "sks_0_7":
            return 335 //205
        case "sks_0_8":
            return 165 //108
        default:
            print("error")
            return 0
        }
    }

}
