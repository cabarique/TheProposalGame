//
//  EnemyMovement.swift
//  MyProposalGame
//
//  Created by Luis Cabarique on 9/21/16.
//  Copyright © 2016 Luis Cabarique. All rights reserved.
//

import SpriteKit
import GameplayKit

class EnemyMovementComponent: GKComponent {
    
    var movementSpeed = CGPoint(x: -30.0, y: 0.0)
    private var skipMovement = 10
    
    var spriteComponent: SpriteComponent {
        guard let spriteComponent = entity?.componentForClass(SpriteComponent.self) else { fatalError("SpriteComponent Missing") }
        return spriteComponent
    }
    
    init(entity: GKEntity) {
        super.init()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        super.updateWithDeltaTime(seconds)
//        if spriteComponent.node.name!.hasPrefix("zombie") && skipMovement == 10{
//            skipMovement = 0
//        }else{
//            skipMovement += 1
//            return
//        }
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

