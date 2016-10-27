//
//  TileLayer2.swift
//  MyProposalGame
//
//  Created by Luis Cabarique on 10/24/16.
//  Copyright © 2016 Luis Cabarique. All rights reserved.
//

import SpriteKit
import GameplayKit

class TileLayer2: TileLayer{
    
    private let _randomSceneryArt = ["Crystal","Igloo","SnowMan","Stone","Tree_1","Tree_2"]

    convenience init(levelIndex: Int, typeIndex: setType) {
        self.init(levelIndex: levelIndex, typeIndex: typeIndex, textureName: "Tiles2" )
    }
    
    override init(levelIndex: Int, typeIndex: setType, textureName: String) {
        super.init(levelIndex: levelIndex, typeIndex: typeIndex, textureName: textureName)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func getRandomSceneryArt() -> [String] {
        return _randomSceneryArt
    }
    
    internal override func createNodeOf(type type:tileType, location:CGPoint, level: Int) {
        
        //Handle each object
        switch type {
        case .tileAir:
            //Intentionally left blank
            if GameSettings.Builder.ALL_Black_Background {
                let node = SKSpriteNode(color: SKColor.blackColor(), size: CGSize(width: 32, height: 32))
                node.position = location
                node.zPosition = GameSettings.GameParams.zValues.zWorld
                addChild(node)
            }
            break
        case .tileGroundLeft:
            let node = SGSpriteNode(texture: atlasTiles.textureNamed("1"))
            node.size = CGSize(width: 32, height: 32)
            node.tileSpriteType = type
            node.position = location
            node.zPosition = GameSettings.GameParams.zValues.zWorld
            
            let physicsComponent = PhysicsComponent(entity: GKEntity(), bodySize: node.size, bodyShape: .square, rotation: false)
            physicsComponent.setCategoryBitmask(ColliderType.Wall.rawValue, dynamic: false)
            physicsComponent.setPhysicsCollisions(ColliderType.Player.rawValue)
            node.physicsBody = physicsComponent.physicsBody
            
            let invisibleWall = SKNode()
            invisibleWall.name = "invisibleWallL"
            invisibleWall.position = CGPointZero
            invisibleWall.zPosition = -1
            
            let invisiblePhysicsComponent = PhysicsComponent(entity: GKEntity(), bodySize: node.size, bodyShape: .leftOutline, rotation: false)
            invisiblePhysicsComponent.setCategoryBitmask(ColliderType.InvisibleWall.rawValue, dynamic: false)
            invisiblePhysicsComponent.setPhysicsCollisions(ColliderType.Enemy.rawValue)
            invisibleWall.physicsBody = invisiblePhysicsComponent.physicsBody
            node.addChild(invisibleWall)
            
            addChild(node)
            break
        case .tileGround:
            let node = SGInOutSpriteNode(texture: atlasTiles.textureNamed("2"))
            node.size = CGSize(width: 32, height: 32)
            node.tileSpriteType = type
            node.position = location
            node.zPosition = GameSettings.GameParams.zValues.zWorld
            
            let physicsComponent = PhysicsComponent(entity: GKEntity(), bodySize: node.size, bodyShape: .topOutline, rotation: false)
            physicsComponent.setCategoryBitmask(ColliderType.Wall.rawValue, dynamic: false)
            physicsComponent.setPhysicsCollisions(ColliderType.Player.rawValue)
            node.physicsBody = physicsComponent.physicsBody
            
            addChild(node)
            break
        case .tileGroundRight:
            let node = SGSpriteNode(texture: atlasTiles.textureNamed("3"))
            node.size = CGSize(width: 32, height: 32)
            node.tileSpriteType = type
            node.position = location
            node.zPosition = GameSettings.GameParams.zValues.zWorld
            
            let physicsComponent = PhysicsComponent(entity: GKEntity(), bodySize: node.size, bodyShape: .square, rotation: false)
            physicsComponent.setCategoryBitmask(ColliderType.Wall.rawValue, dynamic: false)
            physicsComponent.setPhysicsCollisions(ColliderType.Player.rawValue)
            node.physicsBody = physicsComponent.physicsBody
            
            let invisibleWall = SKNode()
            invisibleWall.name = "invisibleWallR"
            invisibleWall.position = CGPointZero
            invisibleWall.zPosition = -1
            
            let invisiblePhysicsComponent = PhysicsComponent(entity: GKEntity(), bodySize: node.size, bodyShape: .rightOutline, rotation: false)
            invisiblePhysicsComponent.setCategoryBitmask(ColliderType.InvisibleWall.rawValue, dynamic: false)
            invisiblePhysicsComponent.setPhysicsCollisions(ColliderType.Enemy.rawValue)
            invisibleWall.physicsBody = invisiblePhysicsComponent.physicsBody
            node.addChild(invisibleWall)
            
            addChild(node)
            break
        case .tileWallLeft:
            let node = SGSpriteNode(texture: atlasTiles.textureNamed("4"))
            node.size = CGSize(width: 32, height: 32)
            node.tileSpriteType = type
            node.position = location
            node.zPosition = GameSettings.GameParams.zValues.zWorld
            
            let physicsComponent = PhysicsComponent(entity: GKEntity(), bodySize: node.size, bodyShape: .square, rotation: false)
            physicsComponent.setCategoryBitmask(ColliderType.Wall.rawValue, dynamic: false)
            physicsComponent.setPhysicsCollisions(ColliderType.Player.rawValue)
            node.physicsBody = physicsComponent.physicsBody
            
            addChild(node)
            break
        case .tileGroundMiddle:
            let node = SGSpriteNode(texture: atlasTiles.textureNamed("5"))
            node.size = CGSize(width: 32, height: 32)
            node.tileSpriteType = type
            node.position = location
            node.zPosition = GameSettings.GameParams.zValues.zWorld
            
            addChild(node)
            break
        case .tileWallRight:
            let node = SGSpriteNode(texture: atlasTiles.textureNamed("6"))
            node.size = CGSize(width: 32, height: 32)
            node.tileSpriteType = type
            node.position = location
            node.zPosition = GameSettings.GameParams.zValues.zWorld
            
            let physicsComponent = PhysicsComponent(entity: GKEntity(), bodySize: node.size, bodyShape: .square, rotation: false)
            physicsComponent.setCategoryBitmask(ColliderType.Wall.rawValue, dynamic: false)
            physicsComponent.setPhysicsCollisions(ColliderType.Player.rawValue)
            node.physicsBody = physicsComponent.physicsBody
            
            addChild(node)
            break
        case .tileGroundCornerR:
            let node = SGInOutSpriteNode(texture: atlasTiles.textureNamed("7"))
            node.size = CGSize(width: 32, height: 32)
            node.tileSpriteType = type
            node.position = location
            node.zPosition = GameSettings.GameParams.zValues.zWorld
            
            let physicsComponent = PhysicsComponent(entity: GKEntity(), bodySize: node.size, bodyShape: .topOutline, rotation: false)
            physicsComponent.setCategoryBitmask(ColliderType.Wall.rawValue, dynamic: false)
            physicsComponent.setPhysicsCollisions(ColliderType.Player.rawValue)
            node.physicsBody = physicsComponent.physicsBody
            
            let invisibleWall = SKNode()
            invisibleWall.name = "invisibleWallR"
            invisibleWall.position = CGPointZero
            invisibleWall.zPosition = -1
            
            let invisiblePhysicsComponent = PhysicsComponent(entity: GKEntity(), bodySize: node.size, bodyShape: .rightOutline, rotation: false)
            invisiblePhysicsComponent.setCategoryBitmask(ColliderType.InvisibleWall.rawValue, dynamic: false)
            invisiblePhysicsComponent.setPhysicsCollisions(ColliderType.Enemy.rawValue)
            invisibleWall.physicsBody = invisiblePhysicsComponent.physicsBody
            node.addChild(invisibleWall)
            
            addChild(node)
            break
        case .tileGroundCornerRU:
            let node = SGSpriteNode(texture: atlasTiles.textureNamed("8"))
            node.size = CGSize(width: 32, height: 32)
            node.tileSpriteType = type
            node.position = location
            node.zPosition = GameSettings.GameParams.zValues.zWorld
            addChild(node)
            break
        case .tileCeiling:
            let node = SGSpriteNode(texture: atlasTiles.textureNamed("9"))
            node.size = CGSize(width: 32, height: 32)
            node.tileSpriteType = type
            node.position = location
            node.zPosition = GameSettings.GameParams.zValues.zWorld
            
            let physicsComponent = PhysicsComponent(entity: GKEntity(), bodySize: node.size, bodyShape: .bottomOutline, rotation: false)
            physicsComponent.setCategoryBitmask(ColliderType.Wall.rawValue, dynamic: false)
            physicsComponent.setPhysicsCollisions(ColliderType.Player.rawValue)
            node.physicsBody = physicsComponent.physicsBody
            
            addChild(node)
            break
        case .tileGroundCornerLU:
            let node = SGSpriteNode(texture: atlasTiles.textureNamed("10"))
            node.size = CGSize(width: 32, height: 32)
            node.tileSpriteType = type
            node.position = location
            node.zPosition = GameSettings.GameParams.zValues.zWorld
            addChild(node)
            break
        case .tileGroundCornerL:
            let node = SGInOutSpriteNode(texture: atlasTiles.textureNamed("11"))
            node.tileSpriteType = type
            node.size = CGSize(width: 32, height: 32)
            node.position = location
            node.zPosition = GameSettings.GameParams.zValues.zWorld
            
            let physicsComponent = PhysicsComponent(entity: GKEntity(), bodySize: node.size, bodyShape: .topOutline, rotation: false)
            physicsComponent.setCategoryBitmask(ColliderType.Wall.rawValue, dynamic: false)
            physicsComponent.setPhysicsCollisions(ColliderType.Player.rawValue)
            node.physicsBody = physicsComponent.physicsBody
            
            let invisibleWall = SKNode()
            invisibleWall.name = "invisibleWallL"
            invisibleWall.position = CGPointZero
            invisibleWall.zPosition = -1
            
            let invisiblePhysicsComponent = PhysicsComponent(entity: GKEntity(), bodySize: node.size, bodyShape: .leftOutline, rotation: false)
            invisiblePhysicsComponent.setCategoryBitmask(ColliderType.InvisibleWall.rawValue, dynamic: false)
            invisiblePhysicsComponent.setPhysicsCollisions(ColliderType.Enemy.rawValue)
            invisibleWall.physicsBody = invisiblePhysicsComponent.physicsBody
            node.addChild(invisibleWall)
            
            addChild(node)
            break
        case .tileCeilingLeft:
            let node = SGSpriteNode(texture: atlasTiles.textureNamed("12"))
            node.size = CGSize(width: 32, height: 32)
            node.tileSpriteType = type
            node.position = location
            node.zPosition = GameSettings.GameParams.zValues.zWorld
            
            let physicsComponent = PhysicsComponent(entity: GKEntity(), bodySize: node.size, bodyShape: .square, rotation: false)
            physicsComponent.setCategoryBitmask(ColliderType.Wall.rawValue, dynamic: false)
            physicsComponent.setPhysicsCollisions(ColliderType.Player.rawValue)
            node.physicsBody = physicsComponent.physicsBody
            
            addChild(node)
            break
        case .tilePlatformLeft:
            let node = SGSpriteNode(texture: atlasTiles.textureNamed("13"))
            node.size = CGSize(width: 32, height: 32)
            node.tileSpriteType = type
            node.position = location
            node.zPosition = GameSettings.GameParams.zValues.zWorld
            
            let physicsComponent = PhysicsComponent(entity: GKEntity(), bodySize: node.size, bodyShape: .square, rotation: false)
            physicsComponent.setCategoryBitmask(ColliderType.Wall.rawValue, dynamic: false)
            physicsComponent.setPhysicsCollisions(ColliderType.Player.rawValue | ColliderType.Enemy.rawValue)
            node.physicsBody = physicsComponent.physicsBody
            
            let invisibleWall = SKNode()
            invisibleWall.name = "invisibleWallL"
            invisibleWall.position = CGPointZero
            invisibleWall.zPosition = -1
            
            let invisiblePhysicsComponent = PhysicsComponent(entity: GKEntity(), bodySize: node.size, bodyShape: .leftOutline, rotation: false)
            invisiblePhysicsComponent.setCategoryBitmask(ColliderType.InvisibleWall.rawValue, dynamic: false)
            invisiblePhysicsComponent.setPhysicsCollisions(ColliderType.Enemy.rawValue)
            invisibleWall.physicsBody = invisiblePhysicsComponent.physicsBody
            node.addChild(invisibleWall)
            
            addChild(node)
            break
        case .tilePlatform:
            let node = SGSpriteNode(texture: atlasTiles.textureNamed("14"))
            node.size = CGSize(width: 32, height: 32)
            node.tileSpriteType = type
            node.position = location
            node.zPosition = GameSettings.GameParams.zValues.zWorld
            
            let physicsComponent = PhysicsComponent(entity: GKEntity(), bodySize: node.size, bodyShape: .square, rotation: false)
            physicsComponent.setCategoryBitmask(ColliderType.Wall.rawValue, dynamic: false)
            physicsComponent.setPhysicsCollisions(ColliderType.Player.rawValue | ColliderType.Enemy.rawValue)
            node.physicsBody = physicsComponent.physicsBody
            
            addChild(node)
            break
        case .tilePlatformRight:
            let node = SGSpriteNode(texture: atlasTiles.textureNamed("15"))
            node.size = CGSize(width: 32, height: 32)
            node.tileSpriteType = type
            node.position = location
            node.zPosition = GameSettings.GameParams.zValues.zWorld
            
            let physicsComponent = PhysicsComponent(entity: GKEntity(), bodySize: node.size, bodyShape: .square, rotation: false)
            physicsComponent.setCategoryBitmask(ColliderType.Wall.rawValue, dynamic: false)
            physicsComponent.setPhysicsCollisions(ColliderType.Player.rawValue | ColliderType.Enemy.rawValue)
            node.physicsBody = physicsComponent.physicsBody
            
            let invisibleWall = SKNode()
            invisibleWall.name = "invisibleWallR"
            invisibleWall.position = CGPointZero
            invisibleWall.zPosition = -1
            
            let invisiblePhysicsComponent = PhysicsComponent(entity: GKEntity(), bodySize: node.size, bodyShape: .rightOutline, rotation: false)
            invisiblePhysicsComponent.setCategoryBitmask(ColliderType.InvisibleWall.rawValue, dynamic: false)
            invisiblePhysicsComponent.setPhysicsCollisions(ColliderType.Enemy.rawValue)
            invisibleWall.physicsBody = invisiblePhysicsComponent.physicsBody
            node.addChild(invisibleWall)
            
            addChild(node)
            break
        case .tileCeilingRight:
            let node = SGSpriteNode(texture: atlasTiles.textureNamed("16"))
            node.size = CGSize(width: 32, height: 32)
            node.tileSpriteType = type
            node.position = location
            node.zPosition = GameSettings.GameParams.zValues.zWorld
            
            let physicsComponent = PhysicsComponent(entity: GKEntity(), bodySize: node.size, bodyShape: .square, rotation: false)
            physicsComponent.setCategoryBitmask(ColliderType.Wall.rawValue, dynamic: false)
            physicsComponent.setPhysicsCollisions(ColliderType.Player.rawValue)
            node.physicsBody = physicsComponent.physicsBody
            
            addChild(node)
            break
        case .tileWaterSurface:
            let node = SGSpriteNode(texture: atlasTiles.textureNamed("17"))
            node.size = CGSize(width: 32, height: 32)
            node.tileSpriteType = type
            node.position = location
            node.zPosition = GameSettings.GameParams.zValues.zWorld
            addChild(node)
            break
        case .tileWater:
            let node = SGSpriteNode(texture: atlasTiles.textureNamed("18"))
            node.size = CGSize(width: 32, height: 32)
            node.tileSpriteType = type
            node.position = location
            node.zPosition = GameSettings.GameParams.zValues.zWorld
            addChild(node)
            break
        case .tileRandomScenery:
            let node = SGSpriteNode(texture: atlasTiles.textureNamed(randomSceneryArt[randomScenery.nextInt() - 1]))
            node.xScale = 0.5
            node.yScale = 0.5
            node.tileSpriteType = type
            node.anchorPoint = CGPoint(x: 0.5, y: 0.0)
            node.position = CGPoint(x: location.x, y: location.y - 16)
            node.zPosition = GameSettings.GameParams.zValues.zWorld
            addChild(node)
            break
        case .tileSignPost:
            let node = SGSpriteNode(texture: atlasTiles.textureNamed("Sign_1"))
            node.size = CGSize(width: 32, height: 32)
            node.tileSpriteType = type
            node.position = location
            node.zPosition = GameSettings.GameParams.zValues.zWorld
            addChild(node)
            break
        case .tileSignArrow:
            let node = SGSpriteNode(texture: atlasTiles.textureNamed("Sign_2"))
            node.size = CGSize(width: 32, height: 32)
            node.tileSpriteType = type
            node.position = location
            node.zPosition = GameSettings.GameParams.zValues.zWorld
            addChild(node)
            break
        case .tileCrate:
            let node = SGSpriteNode(texture: atlasTiles.textureNamed("Crate"))
            node.size = CGSize(width: 32, height: 32)
            node.tileSpriteType = type
            node.position = location
            node.zPosition = GameSettings.GameParams.zValues.zWorld
            node.name = "crateNode"
            
            let physicsComponent = PhysicsComponent(entity: GKEntity(), bodySize: node.size, bodyShape: .square, rotation: false)
            physicsComponent.setCategoryBitmask(ColliderType.Destroyable.rawValue, dynamic: true)
            physicsComponent.setPhysicsCollisions(ColliderType.Player.rawValue | ColliderType.Wall.rawValue | ColliderType.Destroyable.rawValue)
            node.physicsBody = physicsComponent.physicsBody
            
            addChild(node)
            break
        case .tileStartLevel:
            let node = SKNode()
            node.position = CGPoint(x: location.x, y: location.y)
            node.name = "placeholder_StartPoint"
            addChild(node)
            break
        case .tileEndLevel:
            let node = SKNode()
            node.position = location
            node.name = "placeholder_FinishPoint"
            addChild(node)
            break
        case .tileDiamond:
            let node = SKNode()
            node.position = location
            node.name = "placeholder_Diamond"
            addChild(node)
        case .tileCoin:
            let node = SKNode()
            node.position = location
            node.name = "placeholder_Coin"
            addChild(node)
        case .tileZombie:
            let node = SKNode()
            node.position = location
            node.name = "placeholder_Zombie1"
            node.zPosition = GameSettings.GameParams.zValues.zWorld
            addChild(node)
        case .tileZombie2:
            let node = SKNode()
            node.position = location
            node.name = "placeholder_Zombie2"
            node.zPosition = GameSettings.GameParams.zValues.zWorld
            addChild(node)
        case .tileMage1:
            let node = SKNode()
            node.position = location
            node.name = "placeholder_Mage1"
            node.zPosition = GameSettings.GameParams.zValues.zWorld
            addChild(node)
        default:
            break
        }
    }
}

