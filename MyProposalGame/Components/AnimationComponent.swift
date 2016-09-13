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

struct Animation {
  let animationState: AnimationState
  let textures: [SKTexture]
  let repeatTexturesForever: Bool
  let textureSize: CGSize
}

class AnimationComponent: GKComponent {
  
  static let actionKey = "Action"
  static let timePerFrame = NSTimeInterval(1.0 / 20.0)
  
  let node: SKSpriteNode
  var animations: [AnimationState: Animation]
  private(set) var currentAnimation: Animation?
  var requestedAnimationState: AnimationState?

  init(node: SKSpriteNode, animations: [AnimationState: Animation]) {
      self.node = node
      self.animations = animations
  }
  
  private func runAnimationForAnimationState(animationState:
    AnimationState) {

      if currentAnimation != nil &&
        currentAnimation!.animationState == animationState { return }
  
      guard let animation = animations[animationState] else {
        print("Unknown animation for state \(animationState.rawValue)")
        return
      }
      
      node.removeActionForKey(AnimationComponent.actionKey)
      
      let texturesAction: SKAction
      if animation.repeatTexturesForever {
        texturesAction = SKAction.repeatActionForever(
          SKAction.animateWithTextures(animation.textures,
            timePerFrame: AnimationComponent.timePerFrame))
      } else {
        texturesAction = SKAction.animateWithTextures(animation.textures,
          timePerFrame: AnimationComponent.timePerFrame)
      }
      
      node.runAction(texturesAction, withKey: AnimationComponent.actionKey)
      node.size = animation.textureSize
      
      currentAnimation = animation
  }
  
  override func updateWithDeltaTime(deltaTime: NSTimeInterval) {
    super.updateWithDeltaTime(deltaTime)
    if let animationState = requestedAnimationState {
      runAnimationForAnimationState(animationState)
      requestedAnimationState = nil
    }
  }
  
  class func animationFromAtlas(atlas: SKTextureAtlas, withImageIdentifier
    identifier: String, forAnimationState animationState: AnimationState,
    repeatTexturesForever: Bool = true, textureSize:CGSize) -> Animation {
      let textures = atlas.textureNames.filter {
        $0.containsString("\(identifier)")
        }.sort {
          $0 < $1 }.map {
            atlas.textureNamed($0)
      }
      return Animation(
        animationState: animationState,
        textures: textures,
        repeatTexturesForever: repeatTexturesForever,
        textureSize: textureSize
      )
  }
}