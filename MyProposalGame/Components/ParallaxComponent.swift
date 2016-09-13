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

class ParallaxComponent: GKComponent {
  
  var movementFactor = CGPointZero
  var pointOfOrigin = CGPointZero
  var resetLocation = false
  
  var spriteComponent: SpriteComponent {
    guard let spriteComponent = entity?.componentForClass(SpriteComponent.self) else { fatalError("SpriteComponent Missing") }
    return spriteComponent
  }
  
  init(entity: GKEntity, movementFactor factor:CGPoint, spritePosition:CGPoint, reset:Bool) {
    super.init()
    
    movementFactor = factor
    pointOfOrigin = spritePosition
    resetLocation = reset
    
  }
  
  override func updateWithDeltaTime(seconds: NSTimeInterval) {
    super.updateWithDeltaTime(seconds)
    
    //Move Sprite
    spriteComponent.node.position += CGPoint(x: movementFactor.x, y: movementFactor.y)
    
    //Check location
    if (spriteComponent.node.position.x <= (spriteComponent.node.size.width * -1)) && resetLocation == true {
      spriteComponent.node.position = CGPoint(x: spriteComponent.node.size.width, y: 0)
    }
    
    //Add other directions if required.
    
  }
  
}
