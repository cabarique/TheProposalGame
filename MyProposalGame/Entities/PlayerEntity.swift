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

class PlayerEntity: SGEntity {
    
    var spriteComponent: SpriteComponent!
    var animationComponent: AnimationComponent!
    var physicsComponent: PhysicsComponent!
    var scrollerComponent: FullControlComponent!
    
    var gameScene:GamePlayMode!
    var fireNode: SKSpriteNode!
    
    init(position: CGPoint, size: CGSize, firstFrame:SKTexture, atlas: SKTextureAtlas, scene:GamePlayMode) {
        super.init()
        
        gameScene = scene
        
        //Initialize components
        spriteComponent = SpriteComponent(entity: self, texture: SKTexture(), size: size, position:position)
        addComponent(spriteComponent)
        animationComponent = AnimationComponent(node: spriteComponent.node, animations: loadAnimations(atlas))
        addComponent(animationComponent)
        physicsComponent = PhysicsComponent(entity: self, bodySize: CGSize(width: spriteComponent.node.size.width * 0.8, height: spriteComponent.node.size.height * 0.8), bodyShape: .squareOffset, rotation: false)
        physicsComponent.setCategoryBitmask(ColliderType.Player.rawValue, dynamic: true)
        physicsComponent.setPhysicsCollisions(ColliderType.Wall.rawValue | ColliderType.Destroyable.rawValue)
        physicsComponent.setPhysicsContacts(ColliderType.Collectable.rawValue | ColliderType.EndLevel.rawValue | ColliderType.KillZone.rawValue | ColliderType.None.rawValue | ColliderType.Enemy.rawValue | ColliderType.Projectile.rawValue)
        addComponent(physicsComponent)
        scrollerComponent = FullControlComponent(entity: self)
        addComponent(scrollerComponent)
        
        
        //Final setup of components
        spriteComponent.node.physicsBody = physicsComponent.physicsBody
        spriteComponent.node.name = "playerNode"
        name = "playerEntity"
        
        fireNode = SKSpriteNode()
        fireNode.size = CGSize(width: 16, height: 16)
        fireNode.position = CGPoint(x: 28, y: 17)
        fireNode.zPosition = GameSettings.GameParams.zValues.zPlayer + 10
        fireNode.name = "fireNode"
        spriteComponent.node.addChild(fireNode)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadAnimations(textureAtlas:SKTextureAtlas) -> [AnimationState: Animation] {
        var animations = [AnimationState: Animation]()
        
        animations[.Jump] = AnimationComponent.animationFromAtlas(textureAtlas,
                                                                  withImageIdentifier: AnimationState.Jump.rawValue,
                                                                  forAnimationState: .Jump, repeatTexturesForever: false, textureSize: CGSize(width: 48, height: 48.0))
        animations[.Run] = AnimationComponent.animationFromAtlas(textureAtlas,
                                                                 withImageIdentifier: AnimationState.Run.rawValue,
                                                                 forAnimationState: .Run, repeatTexturesForever: true, textureSize: CGSize(width: 48, height: 48.0))
        animations[.Idle] = AnimationComponent.animationFromAtlas(textureAtlas,
                                                                  withImageIdentifier: AnimationState.Idle.rawValue,
                                                                  forAnimationState: .Idle, repeatTexturesForever: true, textureSize: CGSize(width: 48, height: 48))
        animations[.Dead] = AnimationComponent.animationFromAtlas(textureAtlas,
                                                                  withImageIdentifier: AnimationState.Dead.rawValue,
                                                                  forAnimationState: .Dead, repeatTexturesForever: false, textureSize: CGSize(width: 78.857, height: 48))
        
        return animations
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        super.updateWithDeltaTime(seconds)
        
        if !gameScene.worldFrame.contains(spriteComponent.node.position) {
            if spriteComponent.node.position.y < 0 {
                playerDied()
            }
        }
    }
    
    override func contactWith(entity:SGEntity) {
        
        if entity.name == "finishEntity" {
            gameScene.stateMachine.enterState(GameSceneWinState.self)
        }
        
        if entity.name == "gemEntity" {
            if let spriteComponent = entity.componentForClass(SpriteComponent.self) {
                spriteComponent.node.removeFromParent()
                gameScene.diamondsCollected += 1
                gameScene.runAction(gameScene.sndCollectGood)
            }
        }
        
        if entity.name == "coinEntity" {
            if let spriteComponent = entity.componentForClass(SpriteComponent.self) {
                spriteComponent.node.removeFromParent()
                gameScene.coinsCollected += 10
                gameScene.runAction(gameScene.sndCollectGood)
            }
        }
        
        if entity.name.rangeOfString("Zombie") != nil || entity.name.rangeOfString("Mage") != nil
            || entity.name == "BossEntity" || entity.name == "parabolicProjectileEntity" {
            gameScene.control.willDie = true
        }
        
    }
    
    func playerDied() {
        gameScene.stateMachine.enterState(GameSceneLoseState.self)
    }
}
