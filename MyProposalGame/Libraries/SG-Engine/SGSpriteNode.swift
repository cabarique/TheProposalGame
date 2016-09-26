//
//  SGSpriteNode.swift
//  MyProposalGame
//
//  Created by Luis Cabarique on 9/15/16.
//  Copyright © 2016 Luis Cabarique. All rights reserved.
//

import SpriteKit
import GameplayKit

class SGSpriteNode: SKSpriteNode {
    //Defines tile type
    var tileSpriteType: tileType?
}

class SGInOutSpriteNode: SGSpriteNode {
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
        let atlasTiles = SKTextureAtlas(named: "Tiles")
        let notifierNode = SGSpriteNode(texture: atlasTiles.textureNamed("0"))
        notifierNode.tileSpriteType = .tileNotifier
        notifierNode.size = CGSize(width: 32, height: 1)
        notifierNode.position = CGPoint(x: 0, y: 1)
        notifierNode.zPosition = -1
        
        let notifierPhysicsComponent = PhysicsComponent(entity: GKEntity(), bodySize: notifierNode.size, bodyShape: .topOutline, rotation: false)
        notifierPhysicsComponent.setCategoryBitmask(ColliderType.None.rawValue, dynamic: false)
        notifierPhysicsComponent.setPhysicsContacts(ColliderType.Player.rawValue)
        notifierNode.physicsBody = notifierPhysicsComponent.physicsBody
        addChild(notifierNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SGNotifierNode: SKNode {
    //Defines tile type
    var tileSpriteType: tileType?
}
