//
//  ProjectileEntity.swift
//  MyProposalGame
//
//  Created by Luis Cabarique on 9/18/16.
//  Copyright © 2016 Luis Cabarique. All rights reserved.
//

import SpriteKit
import GameplayKit

class ProjectileEntity: SGEntity {
    
    var spriteComponent: SpriteComponent!
    var animationComponent: AnimationComponent!
    var physicsComponent: PhysicsComponent!
    
    var gameScene:GamePlayMode!
    
    private var projectileOrientation: CGFloat = 1.0
    
    init(position: CGPoint, size: CGSize, orientation: CGFloat, texture: SKTexture, scene:GamePlayMode) {
        super.init()
        
        gameScene = scene
        projectileOrientation = orientation
        
        //Initialize components
        spriteComponent = SpriteComponent(entity: self, texture: texture, size: size, position:position)
        spriteComponent.node.xScale = projectileOrientation
        addComponent(spriteComponent)
        physicsComponent = PhysicsComponent(entity: self, bodySize: CGSize(width: spriteComponent.node.size.width * 0.8, height: spriteComponent.node.size.height * 0.8), bodyShape: .squareOffset, rotation: false)
        physicsComponent.setCategoryBitmask(ColliderType.Projectile.rawValue, dynamic: true)
        physicsComponent.setPhysicsCollisions(ColliderType.Wall.rawValue | ColliderType.Destroyable.rawValue)
        physicsComponent.setPhysicsContacts(ColliderType.Enemy.rawValue | ColliderType.Destroyable.rawValue | ColliderType.Enemy.rawValue)
        addComponent(physicsComponent)
        
        
        //Final setup of components
        physicsComponent.physicsBody.affectedByGravity = false
        spriteComponent.node.physicsBody = physicsComponent.physicsBody
        spriteComponent.node.name = "projectileNode"
        name = "projectileEntity"
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        super.updateWithDeltaTime(seconds)
        let allContactedBodies = spriteComponent.node.physicsBody?.allContactedBodies()
        let projectileSpeed = CGPoint(x: 400.0 * projectileOrientation, y: 0.0)
        spriteComponent.node.position += (projectileSpeed * CGFloat(seconds))
        
        if allContactedBodies?.count > 0 {
            for body in allContactedBodies! {
                if body.node is SGSpriteNode {
                    projectileMiss()
                    
                    if body.node?.name == "crateNode" {
                        body.node?.removeFromParent()
                    }
                }
            }
            
        }
        
        if !gameScene.camera!.containsNode(spriteComponent.node) {
            projectileMiss()
        }
    }
    
    
    override func contactWith(entity:SGEntity) {
        
        if entity.name == "zombieEntity" {
           print("")
        }

    }
    
    func projectileMiss() {
        spriteComponent.node.removeFromParent()
    }
}
