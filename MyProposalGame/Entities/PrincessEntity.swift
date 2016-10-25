//
//  PrincessEntity.swift
//  MyProposalGame
//
//  Created by Luis Cabarique on 10/25/16.
//  Copyright © 2016 Luis Cabarique. All rights reserved.
//

import SpriteKit
import GameplayKit

class PrincessEntity: SGEntity {
    var spriteComponent: SpriteComponent!
    var animationComponent: AnimationComponent!
    var physicsComponent: PhysicsComponent!
    
    var gameScene:GamePlayMode!
    
    
    override init() {
        super.init()
    }
    
    init(position: CGPoint, size: CGSize, atlas: SKTextureAtlas, scene:GamePlayMode, name: String) {
        super.init()
        
        gameScene = scene
        //Initialize components
        spriteComponent = SpriteComponent(entity: self, texture: SKTexture(), size: size, position:position)
        spriteComponent.node.xScale = -1
        addComponent(spriteComponent)
        animationComponent = AnimationComponent(node: spriteComponent.node, animations: loadAnimations(atlas))
        animationComponent.requestedAnimationState = .Idle
        addComponent(animationComponent)
        physicsComponent = PhysicsComponent(entity: self, bodySize: CGSize(width: spriteComponent.node.size.width * 0.8, height: spriteComponent.node.size.height * 0.8), bodyShape: .squareOffset, rotation: false)
        
        physicsComponent.setCategoryBitmask(ColliderType.Princess.rawValue, dynamic: true)
        physicsComponent.setPhysicsCollisions(ColliderType.Wall.rawValue)
        addComponent(physicsComponent)
        
        
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
        
        animations[.Idle] = AnimationComponent.animationFromAtlas(textureAtlas,
                                                                  withImageIdentifier: AnimationState.Idle.rawValue,
                                                                  forAnimationState: .Idle, repeatTexturesForever: true, textureSize: CGSize(width: 34.94, height: 55.0))
        
        return animations
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        super.updateWithDeltaTime(seconds)

    }
    
    override func contactWith(entity:SGEntity) {
        
        
        
    }
    
}
