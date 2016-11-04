//
//  ParabolicProjectileEntity.swift
//  MyProposalGame
//
//  Created by Luis Cabarique on 10/26/16.
//  Copyright © 2016 Luis Cabarique. All rights reserved.
//


import SpriteKit
import GameplayKit

class ParabolicProjectileEntity: SGEntity {
    
    var spriteComponent: SpriteComponent!
    var animationComponent: AnimationComponent!
    var physicsComponent: PhysicsComponent!
    
    var gameScene:GamePlayMode!
    
    private var projectileOrientation: CGFloat = 1.0
    private var impulseTime: CGFloat = 0.2
    private var impulseX: Double!
    
    init(position: CGPoint, size: CGSize, orientation: CGFloat, texture: SKTexture, scene:GamePlayMode, impulseX: Double) {
        super.init()
        
        gameScene = scene
        projectileOrientation = orientation
        self.impulseX = impulseX
        //Initialize components
        spriteComponent = SpriteComponent(entity: self, texture: texture, size: size, position:position)
        spriteComponent.node.xScale = projectileOrientation
        spriteComponent.node.anchorPoint.y = 0
        addComponent(spriteComponent)
        physicsComponent = PhysicsComponent(entity: self, bodySize: CGSize(width: spriteComponent.node.size.width * 0.8, height: spriteComponent.node.size.height * 0.8), bodyShape: .squareOffset, rotation: false)
        physicsComponent.setCategoryBitmask(ColliderType.Projectile.rawValue, dynamic: true)
        physicsComponent.setPhysicsCollisions(ColliderType.Wall.rawValue | ColliderType.Destroyable.rawValue)
        physicsComponent.setPhysicsContacts(ColliderType.Player.rawValue)
        addComponent(physicsComponent)
        
        
        //Final setup of components
        physicsComponent.physicsBody.affectedByGravity = true
        spriteComponent.node.physicsBody = physicsComponent.physicsBody
        spriteComponent.node.name = "parabolicProjectileNode"
        name = "parabolicProjectileEntity"
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        super.updateWithDeltaTime(seconds)
        
        if impulseTime > 0 {
            let dy = impulseX != 0 ? (seconds * 100) : (seconds * 90)
            spriteComponent.node.physicsBody?.applyImpulse(CGVector(dx: (seconds * impulseX) * Double(spriteComponent.node.xScale), dy: dy), atPoint: spriteComponent.node.position)
            impulseTime = impulseTime - CGFloat(impulseTime)
        }
        
        let allContactedBodies = spriteComponent.node.physicsBody?.allContactedBodies()
        if allContactedBodies?.count > 0 {
            for body in allContactedBodies! {
                if body.node is SGSpriteNode {
                    projectileMiss()
                }
            }
            
        }
        
        if !gameScene.camera!.containsNode(spriteComponent.node) {
            projectileMiss()
        }
    }
    
    
    override func contactWith(entity:SGEntity) {
        
        
    }
    
    func projectileMiss() {
        spriteComponent.node.removeFromParent()
    }
}
