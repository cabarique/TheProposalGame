//
//  CoinEntity.swift
//  MyProposalGame
//
//  Created by Luis Cabarique on 9/29/16.
//  Copyright © 2016 Luis Cabarique. All rights reserved.
//

import SpriteKit
import GameplayKit

class CoinEntity: SGEntity {
    
    var spriteComponent: SpriteComponent!
    var physicsComponent: PhysicsComponent!
    
    init(position: CGPoint, size: CGSize, texture:SKTexture) {
        super.init()
        
        //Initialize components
        spriteComponent = SpriteComponent(entity: self, texture: texture, size: size, position:position)
        addComponent(spriteComponent)
        physicsComponent = PhysicsComponent(entity: self, bodySize: CGSize(width: spriteComponent.node.size.width * 0.8, height: spriteComponent.node.size.height * 0.8), bodyShape: .square, rotation: false)
        physicsComponent.setCategoryBitmask(ColliderType.Collectable.rawValue, dynamic: false)
        physicsComponent.setPhysicsCollisions(ColliderType.None.rawValue)
        physicsComponent.setPhysicsContacts(ColliderType.Player.rawValue)
        addComponent(physicsComponent)
        
        //Final setup of components
        spriteComponent.node.physicsBody = physicsComponent.physicsBody
        spriteComponent.node.name = "coinNode"
        name = "coinEntity"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

