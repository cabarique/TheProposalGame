//
//  BossEntity.swift
//  MyProposalGame
//
//  Created by Luis Cabarique on 10/25/16.
//  Copyright © 2016 Luis Cabarique. All rights reserved.
//

import SpriteKit
import GameplayKit

class BossEntity: SGEntity {
    var spriteComponent: SpriteComponent!
    var animationComponent: AnimationComponent!
    var physicsComponent: PhysicsComponent!
    var scrollerComponent: MageMovementComponent!
    
    var gameScene:GamePlayMode!
    var didRise: Bool = false
    
    var lifePoints: Int!
    
    override init() {
        super.init()
    }
    
    init(position: CGPoint, size: CGSize, atlas: SKTextureAtlas, scene:GamePlayMode, name: String) {
        super.init()
        
        gameScene = scene
        lifePoints = 20
        //Initialize components
        spriteComponent = SpriteComponent(entity: self, texture: SKTexture(), size: size, position:position)
        spriteComponent.node.xScale = -1
        spriteComponent.node.alpha = 0
        addComponent(spriteComponent)
        animationComponent = AnimationComponent(node: spriteComponent.node, animations: loadAnimations(atlas))
        addComponent(animationComponent)
        physicsComponent = PhysicsComponent(entity: self, bodySize: CGSize(width: spriteComponent.node.size.width * 0.8, height: spriteComponent.node.size.height * 0.8), bodyShape: .squareOffset, rotation: false)
        
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
                                                                    forAnimationState: .Attack, repeatTexturesForever: true, textureSize: CGSize(width: 28.69, height: 48))
        animations[.Dead] = AnimationComponent.animationFromAtlas(textureAtlas,
                                                                  withImageIdentifier: AnimationState.Dead.rawValue,
                                                                  forAnimationState: .Dead, repeatTexturesForever: false, textureSize: CGSize(width: 35.88, height: 55.0))
        animations[.Rise] = AnimationComponent.animationFromAtlas(textureAtlas,
                                                                  withImageIdentifier: AnimationState.Rise.rawValue,
                                                                  forAnimationState: .Rise, repeatTexturesForever: false, textureSize: CGSize(width: 142.85, height: 160))
        animations[.Idle] = AnimationComponent.animationFromAtlas(textureAtlas,
                                                                  withImageIdentifier: AnimationState.Idle.rawValue,
                                                                  forAnimationState: .Idle, repeatTexturesForever: true, textureSize: CGSize(width: 34.22, height: 55.0))
        
        return animations
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        super.updateWithDeltaTime(seconds)
        
        if gameScene.camera?.containsNode(spriteComponent.node) == true && !didRise {
            NSTimer.scheduledTimerWithTimeInterval(0.4, repeats: false, block: { (timer) in
                self.didRise = true
                self.spriteComponent.node.alpha = 1.0
                self.animationComponent.requestedAnimationState = .Rise
            })
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
