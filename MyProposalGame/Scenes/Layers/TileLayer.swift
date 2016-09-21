/*
 * Copyright (c) 2015 Neil North.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import SpriteKit
import GameplayKit

let randomSceneryArt = ["B1","B2","B3","B4","Mushroom_1","Mushroom_2","Stone","Tree_1","Tree_2","Tree_3"]

class TileLayer: SKNode, tileMapDelegate {
    
    var levelGenerator = tileMapBuilder()
    let randomScenery = GKRandomDistribution(forDieWithSideCount: randomSceneryArt.count)
    
    init(levelIndex:Int, typeIndex:setType) {
        super.init()
        
        levelGenerator.delegate = self
        
        levelGenerator.loadLevel(levelIndex, fromSet: typeIndex)
        levelGenerator.presentLayerViaDelegate()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: tileMapDelegate
    
    func createNodeOf(type type:tileType, location:CGPoint) {
        //Load texture atlas
        let atlasTiles = SKTextureAtlas(named: "Tiles")
        
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
            physicsComponent.setPhysicsCollisions(ColliderType.Player.rawValue)
            node.physicsBody = physicsComponent.physicsBody
            
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
            physicsComponent.setPhysicsCollisions(ColliderType.Player.rawValue)
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
            physicsComponent.setPhysicsCollisions(ColliderType.Player.rawValue)
            node.physicsBody = physicsComponent.physicsBody
            
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
            
            let physicsComponent = PhysicsComponent(entity: GKEntity(), bodySize: node.size, bodyShape: .square, rotation: false)
            physicsComponent.setCategoryBitmask(ColliderType.Destroyable.rawValue, dynamic: true)
            physicsComponent.setPhysicsCollisions(ColliderType.Player.rawValue | ColliderType.Wall.rawValue | ColliderType.Destroyable.rawValue)
            node.physicsBody = physicsComponent.physicsBody
            
            addChild(node)
            break
        case .tileGem:
            let node = SKNode()
            node.position = location
            node.name = "placeholder_Gem"
            addChild(node)
            break
        case .tileStartLevel:
            let node = SKNode()
            node.position = CGPoint(x: location.x, y: location.y - 16)
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
        default:
            break
        }
        
        
    }
    
}
