//
//  Mage2Entity.swift
//  MyProposalGame
//
//  Created by Luis Cabarique on 10/25/16.
//  Copyright © 2016 Luis Cabarique. All rights reserved.
//

import SpriteKit
import GameplayKit

class Mage2Entity: SGEntity, ParabolicAttacking {
    var spriteComponent: SpriteComponent!
    var animationComponent: AnimationComponent!
    var physicsComponent: PhysicsComponent!
    var scrollerComponent: MageMovementComponent!
    
    var gameScene:GamePlayMode!
    var didRise: Bool = false
    var riseTime: CGFloat = 0.2
    
    var lifePoints: Int!
    
    override init() {
        super.init()
    }
    
    init(position: CGPoint, size: CGSize, atlas: SKTextureAtlas, scene:GamePlayMode, name: String) {
        super.init()
        
        gameScene = scene
        lifePoints = 1
        //Initialize components
        spriteComponent = SpriteComponent(entity: self, texture: SKTexture(), size: size, position:position)
        spriteComponent.node.xScale = -1
        spriteComponent.node.alpha = 0
        addComponent(spriteComponent)
        animationComponent = AnimationComponent(node: spriteComponent.node, animations: loadAnimations(atlas))
        addComponent(animationComponent)
        physicsComponent = PhysicsComponent(entity: self, bodySize: CGSize(width: spriteComponent.node.size.width * 0.6, height: spriteComponent.node.size.height * 0.8), bodyShape: .squareOffset, rotation: false)
        
        enablePhysicContacts()
        addComponent(physicsComponent)
        scrollerComponent = MageMovementComponent(entity: self)
        scrollerComponent.lifePoints = lifePoints
        addComponent(scrollerComponent)
        
        
        //Final setup of components
        spriteComponent.node.physicsBody = physicsComponent.physicsBody
        spriteComponent.node.name = "\(name)Node"
        self.name = "\(name)Entity"
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadAnimations(textureAtlas:SKTextureAtlas) -> [AnimationState: Animation] {
        var animations = [AnimationState: Animation]()
        
        animations[.Attack] = AnimationComponent.animationFromAtlas(textureAtlas,
                                                                    withImageIdentifier: AnimationState.Attack.rawValue,
                                                                    forAnimationState: .Attack, repeatTexturesForever: false, textureSize: CGSize(width: 35.86, height: 60.0))
        animations[.Dead] = AnimationComponent.animationFromAtlas(textureAtlas,
                                                                  withImageIdentifier: AnimationState.Dead.rawValue,
                                                                  forAnimationState: .Dead, repeatTexturesForever: false, textureSize: CGSize(width: 56.62, height: 60.0))
        animations[.Rise] = AnimationComponent.animationFromAtlas(textureAtlas,
                                                                  withImageIdentifier: AnimationState.Rise.rawValue,
                                                                  forAnimationState: .Rise, repeatTexturesForever: false, textureSize: CGSize(width: 35.05, height: 60.0))
        animations[.Idle] = AnimationComponent.animationFromAtlas(textureAtlas,
                                                                  withImageIdentifier: AnimationState.Idle.rawValue,
                                                                  forAnimationState: .Idle, repeatTexturesForever: true, textureSize: CGSize(width: 38.11, height: 60.0))
        return animations
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        super.updateWithDeltaTime(seconds)
        
        if !didRise && gameScene.camera?.containsNode(spriteComponent.node) == true {
            riseTime = riseTime - CGFloat(seconds)
            if riseTime < 0 {
                self.didRise = true
                self.spriteComponent.node.alpha = 1.0
                self.animationComponent.requestedAnimationState = .Rise
            }
        }
        
        if gameScene.camera?.containsNode(spriteComponent.node) == true {
            if gameScene.camera?.position.x < spriteComponent.node.position.x{
                spriteComponent.node.xScale = -1
            }else{
                spriteComponent.node.xScale = 1
            }
        }
    }
    
    override func contactWith(entity:SGEntity) {
        if entity.name == "projectileEntity" {
            
        }
        
        
    }
    
    func EnemyDied() {
        
    }
    
    func enablePhysicContacts(){
        physicsComponent.setCategoryBitmask(ColliderType.Enemy.rawValue, dynamic: true)
        physicsComponent.setPhysicsContacts(ColliderType.Projectile.rawValue | ColliderType.Player.rawValue)
        physicsComponent.setPhysicsCollisions(ColliderType.Wall.rawValue | ColliderType.InvisibleWall.rawValue | ColliderType.Destroyable.rawValue)
    }
}

