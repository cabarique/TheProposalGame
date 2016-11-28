//
//  GroundProjectileEntity.swift
//  MyProposalGame
//
//  Created by Luis Cabarique on 11/3/16.
//  Copyright © 2016 Luis Cabarique. All rights reserved.
//

import SpriteKit
import GameplayKit

class GroundProjectileEntity: SGEntity {
    
    var spriteComponent: SpriteComponent!
    var animationComponent: AnimationComponent!
    var physicsComponent: PhysicsComponent!
    
    var gameScene:GamePlayMode!
    
    private var projectileOrientation: CGFloat = 1.0
    private let speed: CGPoint = CGPoint(x: 30.0, y: 0.0)
    
    init(position: CGPoint, size: CGSize, orientation: CGFloat, texture: SKTexture, scene:GamePlayMode) {
        super.init()
        
        gameScene = scene
        projectileOrientation = orientation
        //Initialize components
        spriteComponent = SpriteComponent(entity: self, texture: texture, size: size, position:position)
        spriteComponent.node.xScale = projectileOrientation
        spriteComponent.node.anchorPoint.y = 0
        addComponent(spriteComponent)
        physicsComponent = PhysicsComponent(entity: self, bodySize: size, bodyShape: .squareOffset, rotation: false)
        physicsComponent.setCategoryBitmask(ColliderType.Projectile.rawValue, dynamic: true)
        physicsComponent.setPhysicsCollisions(ColliderType.Wall.rawValue | ColliderType.Destroyable.rawValue)
        physicsComponent.setPhysicsContacts(ColliderType.Player.rawValue)
        
        addComponent(physicsComponent)
        
        
        //Final setup of components
        physicsComponent.physicsBody.affectedByGravity = true
        spriteComponent.node.physicsBody = physicsComponent.physicsBody
        spriteComponent.node.name = "groundProjectileNode"
        name = "groundProjectileEntity"
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        super.updateWithDeltaTime(seconds)
        
        let projectileSpeed = CGPoint(x: speed.x * projectileOrientation, y: speed.y)
        spriteComponent.node.position += (projectileSpeed * CGFloat(seconds))
        
        let allContactedBodies = spriteComponent.node.physicsBody?.allContactedBodies()
        if allContactedBodies?.count > 0 {
            for body in allContactedBodies! {
                let nodeDif = (body.node?.position)! - spriteComponent.node.position
                let nodeDir = nodeDif.angle
                if body.node is SGSpriteNode {
                    let leftAngle: CGFloat = 2.6
                    let rightAngle: CGFloat = 0.5
                    if ( nodeDir > (leftAngle - 0.4) && nodeDir < (leftAngle + 0.4) && spriteComponent.node.xScale == -1 ) ||
                        ( nodeDir > (rightAngle - 0.4) && nodeDir < (rightAngle + 0.4) && spriteComponent.node.xScale == 1) {
                            projectileMiss()
                    }

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
