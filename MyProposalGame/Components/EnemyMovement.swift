//
//  EnemyMovement.swift
//  MyProposalGame
//
//  Created by Luis Cabarique on 9/21/16.
//  Copyright © 2016 Luis Cabarique. All rights reserved.
//

import SpriteKit
import GameplayKit

struct EnemyMoveControlScheme {
    
    //Input
    //var willDie: Bool               = false
}

class EnemyControlComponentSystem: GKComponentSystem {
    
    func updateWithDeltaTime(seconds: NSTimeInterval, controlInput: EnemyMoveControlScheme) {
        for component in components {
            if let comp = component as? EnemyMovementComponent {
                comp.updateWithDeltaTime(seconds, controlInput: controlInput)
            }
        }
    }
}

class EnemyMovementComponent: GKComponent {
    
    var movementSpeed = CGPoint(x: -30.0, y: 0.0)
    private var skipMovement = 10
    var isDying = false
    var deadTime: CGFloat = 0.0
    
    var spriteComponent: SpriteComponent {
        guard let spriteComponent = entity?.componentForClass(SpriteComponent.self) else { fatalError("SpriteComponent Missing") }
        return spriteComponent
    }
    
    var animationComponent: AnimationComponent {
        guard let animationComponent = entity?.componentForClass(AnimationComponent.self) else { fatalError("AnimationComponent Missing") }
        return animationComponent
    }
    
    init(entity: GKEntity) {
        super.init()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateWithDeltaTime(seconds: NSTimeInterval, controlInput: EnemyMoveControlScheme) {
        super.updateWithDeltaTime(seconds)
        
        if isDying && deadTime > 0{
            deadTime = deadTime - CGFloat(seconds)
            return
        }
        
        if deadTime <= 0 && isDying {
            spriteComponent.node.removeFromParent()
            return
        }
        
        let allContactedBodies = spriteComponent.node.physicsBody?.allContactedBodies()
        
        //Move sprite
        if movementSpeed.x >= 0 {
            spriteComponent.node.xScale = 1.0
        }else{
            spriteComponent.node.xScale = -1.0
        }
        spriteComponent.node.position += (movementSpeed * CGFloat(seconds))
        
        //when contacts with a tile, turns arround
        if allContactedBodies?.count > 0 {
            for body in allContactedBodies! {
                let nodeDif = (body.node?.position)! - spriteComponent.node.position
                let nodeDir = nodeDif.angle
                
                if !isDying && body.node?.name == "projectileNode" {
                    body.node?.removeFromParent()
                    if let enemyEnt = entity as? EnemyEntity {
                        enemyEnt.gameScene.runAction(enemyEnt.gameScene.sndJump)
                        animationComponent.requestedAnimationState = .Dead
                        isDying = true
                        deadTime = 1
                        return
                    }
                }
                
                if body.node is SGSpriteNode {
                    let leftAngle: CGFloat = 2.5852
                    let rightAngle: CGFloat = 0.5564
                    if ( nodeDir > (leftAngle - 0.01) && nodeDir < (leftAngle + 0.01) && spriteComponent.node.xScale == -1 ) ||
                        ( nodeDir > (rightAngle - 0.01) && nodeDir < (rightAngle + 0.01) && spriteComponent.node.xScale == 1) {
                        movementSpeed.x *= -1
                    }
                }
            }
        }
        
    }
    
}

