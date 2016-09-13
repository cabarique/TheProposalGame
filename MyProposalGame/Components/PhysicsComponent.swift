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

enum PhysicsBodyShape {
  case square
  case squareOffset
  case circle
  case topOutline
  case bottomOutline
}

class PhysicsComponent: GKComponent {
  
  var physicsBody = SKPhysicsBody()
  
  init(entity: GKEntity, bodySize: CGSize, bodyShape: PhysicsBodyShape, rotation: Bool) {
    
    switch bodyShape {
    case.square:
      physicsBody = SKPhysicsBody(rectangleOfSize: bodySize)
      break
    case.squareOffset:
      physicsBody = SKPhysicsBody(rectangleOfSize: bodySize, center: CGPoint(x: 0, y: bodySize.height/2 + 2))
      break
    case .circle:
      physicsBody = SKPhysicsBody(circleOfRadius: bodySize.width / 2)
      break
    case .topOutline:
      physicsBody = SKPhysicsBody(edgeFromPoint: CGPoint(x: (bodySize.width/2) * -1, y: bodySize.height/2), toPoint: CGPoint(x: bodySize.width/2, y: bodySize.height/2))
      break
    case .bottomOutline:
      physicsBody = SKPhysicsBody(edgeFromPoint: CGPoint(x: (bodySize.width/2) * -1, y: (bodySize.height/2) * -1), toPoint: CGPoint(x: bodySize.width/2, y: (bodySize.height/2) * -1))
      break
    }
    
    physicsBody.allowsRotation = rotation
    
    //Defaults
    physicsBody.dynamic = true
    physicsBody.contactTestBitMask = ColliderType.None.rawValue
    physicsBody.collisionBitMask = ColliderType.None.rawValue
  }
  
  func setCategoryBitmask(bitmask:UInt32, dynamic: Bool) {
    
    physicsBody.categoryBitMask = bitmask
    physicsBody.dynamic = dynamic
    
  }
  
  func setPhysicsCollisions(bitmask:UInt32) {
    
    physicsBody.collisionBitMask = bitmask
    
  }
  
  func setPhysicsContacts(bitmask:UInt32) {
    
    physicsBody.contactTestBitMask = bitmask
    
  }
  
}
