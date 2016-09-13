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
    var jumpPressed:Bool = false
    var throwPressed:Bool = false
    
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
    var jumpTime:CGFloat = 0.0
    var isThrowing = false
    
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
    
    func updateWithDeltaTime(seconds: NSTimeInterval, controlInput: FullMoveControlScheme) {
        super.updateWithDeltaTime(seconds)
        
        //Move sprite
        spriteComponent.node.position += (controlInput.movement * (movementSpeed * CGFloat(seconds)))
        
        if controlInput.movement.x == 0 {
            //Don't change orientation
        } else if (controlInput.movement.x > 0) {
            spriteComponent.node.xScale = 1.0
        } else {
            spriteComponent.node.xScale = -1.0
        }
        
        //Jump
        if controlInput.jumpPressed && !isJumping {
            if let playerEnt = entity as? PlayerEntity {
                playerEnt.gameScene.runAction(playerEnt.gameScene.sndJump)
            }
            isJumping = true
            jumpTime = 0.2
            animationComponent.requestedAnimationState = .Jump
        }
        if (jumpTime > 0.0) {
            jumpTime = jumpTime - CGFloat(seconds)
            spriteComponent.node.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: (seconds * 25.0)), atPoint: spriteComponent.node.position)
            return
        }
        
        if spriteComponent.node.physicsBody?.allContactedBodies().count > 0 {
            for body in (spriteComponent.node.physicsBody?.allContactedBodies())! {
                let nodeDir = ((body.node?.position)! - spriteComponent.node.position).angle
                if (nodeDir > -2.355 && nodeDir < -0.785) {
                    isJumping = false
                    
                    if (controlInput.movement.x > 0.1 || controlInput.movement.x < -0.1) {
                        animationComponent.requestedAnimationState = .Run
                    } else {
                        animationComponent.requestedAnimationState = .Idle
                    }
                }
            }
        }
        
        //Throw
        
    }
    
    
}


