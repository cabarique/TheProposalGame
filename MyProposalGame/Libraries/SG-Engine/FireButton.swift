//
//  FireButton.swift
//  MyProposalGame
//
//  Created by Luis Cabarique on 9/18/16.
//  Copyright © 2016 Luis Cabarique. All rights reserved.
//


import SpriteKit
import GameplayKit

class FireButton: SKNode {
    
    var button = SKSpriteNode()
    var touchArea: SKSpriteNode!
    var firePressed = false
    
    var zPos:CGFloat = 1000
    
    init(buttonName: String) {
        
        let atlas = SKTextureAtlas(named: "Button")
        touchArea = SKSpriteNode()
        touchArea.size = CGSize(width: 130, height: 130)
        touchArea.color = SKColor.clearColor()
        
        button = SKSpriteNode(texture: atlas.textureNamed("game"))
        button.zPosition = zPos
        button.alpha = 0.5
        button.size = CGSize(width: 100, height: 100)
        touchArea.addChild(button)
        
        super.init()
        
        self.name = buttonName
        self.userInteractionEnabled = true
        
        self.addChild(touchArea)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: handle interactions
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for _ in touches {
            button.alpha = 1.0
            firePressed = true
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        button.alpha = 0.5
        firePressed = false
        self.userInteractionEnabled = false
        NSTimer.scheduledTimerWithTimeInterval(0.1, repeats: false) { (timer) in
            self.userInteractionEnabled = true
        }
    }
    
}

