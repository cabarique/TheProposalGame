//
//  JumpButton.swift
//  MyProposalGame
//
//  Created by Luis Cabarique on 9/18/16.
//  Copyright © 2016 Luis Cabarique. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class JumpButton: SKNode {
    
    var button = SKSpriteNode()
    let radius:CGFloat
    var jumpPressed = false
    
    var zPos:CGFloat = 1000
    
    init(buttonName: String) {
        
        let atlas = SKTextureAtlas(named: "Button")
        
        button = SKSpriteNode(texture: atlas.textureNamed("arrowU"))
        button.zPosition = zPos
        button.alpha = 0.5
        button.size = CGSize(width: 90, height: 90)
        
        radius = button.size.width
        
        super.init()
        
        self.name = buttonName
        self.userInteractionEnabled = true
 
        self.addChild(button)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: handle interactions
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for _ in touches {
            button.alpha = 1.0
            jumpPressed = true
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        button.alpha = 0.5
        jumpPressed = false
    }
    
}
