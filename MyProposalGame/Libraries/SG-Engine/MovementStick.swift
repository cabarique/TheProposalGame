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

import Foundation
import SpriteKit
import GameplayKit

class MovementStick: SKNode {
    
    var stick = SKSpriteNode()
    let radius:CGFloat
    var movement:CGPoint { get {return CGPoint(x: stick.position.x / radius, y: stick.position.y / radius)}}
    
    var zPos:CGFloat = 1000
    
    init(stickName: String) {
        
        let atlas = SKTextureAtlas(named: "GUI")
        
        let background = SKSpriteNode(texture: atlas.textureNamed("stick_bounds"))
        background.zPosition = zPos
        background.size = CGSize(width: 150, height: 150)
        radius = background.size.width/2
        
        super.init()
        
        self.name = stickName
        self.userInteractionEnabled = true
        
        stick = SKSpriteNode(texture: atlas.textureNamed("Joystick"))
        stick.size = CGSize(width: 80, height: 80)
        stick.alpha = 0.7
        stick.zPosition = zPos + 1
        
        self.addChild(background)
        self.addChild(stick)
        
        let constraint = SKConstraint.distance(SKRange(upperLimit: background.size.width/2), toPoint: CGPointZero)
        stick.constraints = [constraint]
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: handle interactions
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            let location = touch.locationInNode(self)
            stick.position = location
            
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            let location = touch.locationInNode(self)
            stick.position = location
            
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        stick.position = CGPointZero
    }
    
}
