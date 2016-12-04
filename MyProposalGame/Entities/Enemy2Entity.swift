//
//  EnemyEntity.swift
//  MyProposalGame
//
//  Created by Luis Cabarique on 9/21/16.
//  Copyright © 2016 Luis Cabarique. All rights reserved.
//

import SpriteKit
import GameplayKit

class Enemy2Entity: EnemyEntity {
    
    override init(position: CGPoint, size: CGSize, atlas: SKTextureAtlas, scene: GamePlayMode, name: String) {
        super.init()
        self.gameScene = scene
        self.lifePoints = 2
        //Initialize components
        let texture = SKTexture(image: UIImage.imageWithColor(SKColor.clearColor()))
        self.spriteComponent = SpriteComponent(entity: self, texture: texture, size: size, position:position)
        self.spriteComponent.node.xScale = -1
        self.spriteComponent.node.alpha = 0
        addComponent(self.spriteComponent)
        self.animationComponent = AnimationComponent(node: self.spriteComponent.node, animations: loadAnimations(atlas))
        addComponent(animationComponent)
        physicsComponent = PhysicsComponent(entity: self, bodySize: CGSize(width: spriteComponent.node.size.width * 0.6, height: spriteComponent.node.size.height * 0.8), bodyShape: .squareOffset, rotation: false)
        
        enablePhysicContacts()
        addComponent(physicsComponent)
        scrollerComponent = EnemyMovementComponent(entity: self)
        scrollerComponent.lifePoints = lifePoints
        addComponent(scrollerComponent)
        
        
        //Final setup of components
        spriteComponent.node.physicsBody = physicsComponent.physicsBody
        spriteComponent.node.name = "\(name)Node"
        self.name = "\(name)Entity"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
