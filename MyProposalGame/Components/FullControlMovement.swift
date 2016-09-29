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

struct FullMoveControlScheme {
    
    //Input
    var jumpPressed:Bool            = false
    var firePressed:Bool            = false
    var willDie: Bool               = false
    
    var movement:CGPoint = CGPointZero
    
}

class FullControlComponentSystem: GKComponentSystem {
    
    func updateWithDeltaTime(seconds: NSTimeInterval, controlInput: FullMoveControlScheme) {
        for component in components {
            if let comp = component as? FullControlComponent {
                comp.updateWithDeltaTime(seconds, controlInput: controlInput)
            }
        }
    }
}

class FullControlComponent: GKComponent {
    
    var movementSpeed = CGPoint(x: 90.0, y: 0.0)
    
    //State
    var isJumping = false
    var isDoubleJumping = false
    var jumpTime:CGFloat = 0.0
    
    var isFiring = false
    var fireTime: CGFloat = 0.0
    
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
    
    func updateWithDeltaTime(seconds: NSTimeInterval, controlInput: FullMoveControlScheme) {
        super.updateWithDeltaTime(seconds)
        if controlInput.willDie && !isDying {
            if let playerEnt = entity as? PlayerEntity {
                playerEnt.gameScene.runAction(SKAction.sequence([playerEnt.gameScene.sndMeow2, SKAction.waitForDuration(0.8), playerEnt.gameScene.sndDead]))
            }
            isDying = true
            deadTime = 3
            animationComponent.requestedAnimationState = .Dead
            return
        }
        if deadTime > 0 {
            deadTime = deadTime - CGFloat(seconds)
            return
        }
        if deadTime <= 0 && isDying {
            if let playerEnt = entity as? PlayerEntity {
                playerEnt.gameScene.stateMachine.enterState(GameSceneLoseState.self)
            }
            return
        }
        let allContactedBodies = spriteComponent.node.physicsBody?.allContactedBodies()
        //Move sprite
        spriteComponent.node.position += (controlInput.movement * (movementSpeed * CGFloat(seconds))) // < 1
        
        if controlInput.movement.x == 0 {
            //Don't change orientation
        } else if (controlInput.movement.x > 0) {
            spriteComponent.node.xScale = 1.0
        } else {
            spriteComponent.node.xScale = -1.0
        }
        
        //Jump
        if controlInput.jumpPressed && !isJumping && allContactedBodies?.count > 0 {
            if let playerEnt = entity as? PlayerEntity {
                playerEnt.gameScene.runAction(playerEnt.gameScene.sndJump)
            }
            isJumping = true
            jumpTime = 0.1
            animationComponent.requestedAnimationState = .Jump
        }else if controlInput.jumpPressed && isJumping && isDoubleJumping == false { //double jumping
            if let playerEnt = entity as? PlayerEntity {
                playerEnt.gameScene.runAction(playerEnt.gameScene.sndJump)
            }
            isJumping = true
            isDoubleJumping = true
            
            jumpTime = 0.12
            animationComponent.requestedAnimationState = .Jump
        }
        
        if (jumpTime > 0.0) {
            jumpTime = jumpTime - CGFloat(seconds)
            spriteComponent.node.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: (seconds * 43)), atPoint: spriteComponent.node.position)
            return
        }
        
        if controlInput.firePressed && !isFiring {
            if let playerEnt = entity as? PlayerEntity {
                playerEnt.gameScene.runAction(playerEnt.gameScene.sndFire)
            }
            fireTime = fireTime > 0 ? fireTime : 0.5
            animationComponent.requestedAnimationState = .IdleFire
        }
        if (fireTime > 0.0) {
            fireTime = fireTime - CGFloat(seconds)
            return
        }
        
        if allContactedBodies?.count > 0 {
            for body in allContactedBodies! {
                let nodeDif = (body.node?.position)! - spriteComponent.node.position
                let nodeDir = nodeDif.angle
                
                if (nodeDir > -2.355 && nodeDir < -0.785 /*&& nodeDif.y < -16.56*/) {
                    isJumping = false
                    isDoubleJumping = false
                    
                    if (controlInput.movement.x > 0.1 || controlInput.movement.x < -0.1) {
                        animationComponent.requestedAnimationState = .Run
                    } else {
                        animationComponent.requestedAnimationState = .Idle
                    }
                }
                
                if  nodeDir < 0.05 {
                    if let inOutTile = body.node as? SGSpriteNode where
                        inOutTile.tileSpriteType == .tileGroundCornerL || inOutTile.tileSpriteType == .tileGroundCornerR || inOutTile.tileSpriteType == .tileGround {
                        if body.node?.physicsBody?.categoryBitMask == ColliderType.None.rawValue && nodeDif.y < -5 {
                            body.node?.physicsBody?.categoryBitMask = ColliderType.Wall.rawValue
                        }
                    }
                }
                else  {
                    if let inOutTile = body.node as? SGSpriteNode where
                        inOutTile.tileSpriteType == .tileNotifier || inOutTile.tileSpriteType == .tileGroundCornerR || inOutTile.tileSpriteType == .tileGround {
                        body.node?.parent!.physicsBody?.categoryBitMask = ColliderType.None.rawValue
                    }
                }
            }
        }
    }
}


