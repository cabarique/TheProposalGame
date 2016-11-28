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
    private var backGroundSize: CGFloat = 200
    var movement:CGPoint {
        get {
            let x = fabs(stick.position.x) <= 75 ? stick.position.x : ( stick.position.x > 0 ? (backGroundSize / 2) : -1 * (backGroundSize / 2) )
            let y = fabs(stick.position.y) <= 75 ? stick.position.y : ( stick.position.y > 0 ? (backGroundSize / 2) : -1 * (backGroundSize / 2) )
            return CGPoint(x: x / radius, y: y / radius)
        }
    }
    
    var zPos:CGFloat = 1000
    
    init(stickName: String) {
        
        let atlas = SKTextureAtlas(named: "GUI")
        
        let background = SKSpriteNode(texture: atlas.textureNamed("stick_bounds"))
        background.zPosition = zPos
        background.size = CGSize(width: backGroundSize, height: backGroundSize)
        radius = background.size.width/2
        
        super.init()
        
        self.name = stickName
        self.userInteractionEnabled = true
        
        stick = SKSpriteNode(texture: atlas.textureNamed("Joystick"))
        stick.size = CGSize(width: 90, height: 90)
        stick.alpha = 0.5
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
            stick.alpha = 1.0
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            let location = touch.locationInNode(self)
            stick.position = location
            stick.alpha = 1.0
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        stick.position = CGPointZero
        stick.alpha = 0.5
    }
    
}
