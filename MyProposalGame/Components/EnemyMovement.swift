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
    //    var didRise: Bool = false
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
    var isDying = false
    var deadTime: CGFloat = 0.0
    var isActive: Bool = false
    var riseTime: CGFloat = 0.0
    
    var lifePoints = 1
    
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
        guard let enemyEnt = entity as? EnemyEntity else{ fatalError("Enemy entity missing") }
        
        if enemyEnt.didRise {
            
            if !isActive {
                if riseTime == 0 {
                    riseTime = 0.4
                }else if riseTime > 0 {
                    riseTime = riseTime - CGFloat(seconds)
                }else{
                    isActive = true
                    enemyEnt.enablePhysicContacts()
                }
                return
            }
            
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
            if movementSpeed.x > 0 {
                spriteComponent.node.xScale = 1.0
            }else{
                spriteComponent.node.xScale = -1.0
            }
            spriteComponent.node.position += (movementSpeed * CGFloat(seconds))
            
            //when contacts with a tile, turns arround
            if allContactedBodies?.count > 0 {
                for body in allContactedBodies! {
                    
                    if lifePoints > 0 && body.node?.name == "projectileNode" && isActive {
                        lifePoints -= 1
                        body.node?.removeFromParent()
                    }
                    
                    if !isDying && body.node?.name == "projectileNode" && isActive && lifePoints == 0 {
                        body.node?.removeFromParent()
                        spriteComponent.node.physicsBody = nil
                        enemyEnt.gameScene.runAction(enemyEnt.gameScene.sndJump)
                        animationComponent.requestedAnimationState = .Dead
                        isDying = true
                        deadTime = 1
                        return
                    }
                    
                    let gameScene = enemyEnt.gameScene
                    if gameScene.camera?.containsNode(spriteComponent.node) == true {
                        animationComponent.requestedAnimationState = .Run
                        let dif = abs(abs((gameScene.camera?.position.x)!) - abs(spriteComponent.node.position.x) )
                        if dif > 0  &&  dif < 15{
                            movementSpeed.x = 0
                            animationComponent.requestedAnimationState = .Idle
                        }else if gameScene.camera?.position.x < spriteComponent.node.position.x {
                            movementSpeed.x = -30
                        }else{
                            movementSpeed.x = 30
                        }
                    }
                    
//                    if body.node?.name == "invisibleWallL" && movementSpeed.x < 0 ||
//                        body.node?.name == "invisibleWallR" && movementSpeed.x > 0{
//                        movementSpeed.x *= -1
//                    }else if body.node is SGSpriteNode {
//                        animationComponent.requestedAnimationState = .Run
//                        let leftAngle: CGFloat = 2.3
//                        let rightAngle: CGFloat = 0.5
//                        if ( nodeDir > (leftAngle - 0.4) && nodeDir < (leftAngle + 0.4) && spriteComponent.node.xScale == -1 ) {
//                            movementSpeed.x = 30
//                        }else if ( nodeDir > (rightAngle - 0.4) && nodeDir < (rightAngle + 0.4) && spriteComponent.node.xScale == 1){
//                            movementSpeed.x = -30
//                        }
//                    }
                }
            }
        }
        
    }
    
}

