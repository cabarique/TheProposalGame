//
//  MageMovement.swift
//  MyProposalGame
//
//  Created by Luis Cabarique on 10/24/16.
//  Copyright © 2016 Luis Cabarique. All rights reserved.
//


import SpriteKit
import GameplayKit

struct MageMoveControlScheme {
    
    //Input
    //    var didRise: Bool = false
    //var willDie: Bool               = false
}

class MageControlComponentSystem: GKComponentSystem {
    
    func updateWithDeltaTime(seconds: NSTimeInterval, controlInput: MageMoveControlScheme) {
        for component in components {
            if let comp = component as? MageMovementComponent {
                comp.updateWithDeltaTime(seconds, controlInput: controlInput)
            }
        }
    }
}

class MageMovementComponent: GKComponent {
    
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
    
    func updateWithDeltaTime(seconds: NSTimeInterval, controlInput: MageMoveControlScheme) {
        super.updateWithDeltaTime(seconds)
        
        if let enemyEnt = entity as? Mage1Entity {
            updateMage1WithDeltaTime(seconds, controlInput: controlInput, enemyEnt: enemyEnt)
        }else {
            updateMage2WithDeltaTime(seconds, controlInput: controlInput, enemyEnt: entity as! Mage2Entity)
        }
    }
    
    func updateMage1WithDeltaTime(seconds: NSTimeInterval, controlInput: MageMoveControlScheme, enemyEnt: Mage1Entity){
        if enemyEnt.didRise {
            
            if !isActive {
                if riseTime == 0 {
                    riseTime = 0.4
                }else if riseTime > 0 {
                    riseTime = riseTime - CGFloat(seconds)
                }else{
                    isActive = true
                    enemyEnt.enablePhysicContacts()
                    animationComponent.requestedAnimationState = .Idle
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
            
            //when contacts with a tile, turns arround
            if allContactedBodies?.count > 0 {
                for body in allContactedBodies! {
                    let nodeDif = (body.node?.position)! - spriteComponent.node.position
                    let nodeDir = nodeDif.angle
                    
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
                }
            }
        }
    }
    
    func updateMage2WithDeltaTime(seconds: NSTimeInterval, controlInput: MageMoveControlScheme, enemyEnt: Mage2Entity){
        if enemyEnt.didRise {
            
            if !isActive {
                if riseTime == 0 {
                    riseTime = 0.4
                }else if riseTime > 0 {
                    riseTime = riseTime - CGFloat(seconds)
                }else{
                    isActive = true
                    enemyEnt.enablePhysicContacts()
                    animationComponent.requestedAnimationState = .Idle
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
            
            //when contacts with a tile, turns arround
            if allContactedBodies?.count > 0 {
                for body in allContactedBodies! {
                    let nodeDif = (body.node?.position)! - spriteComponent.node.position
                    let nodeDir = nodeDif.angle
                    
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
                }
            }
        }
    }
    
}
