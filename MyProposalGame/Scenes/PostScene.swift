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

class PostScreen: SGScene {
  
  var level:Int?
  var win:Bool?
  var gems:Int?
  
  override func didMoveToView(view: SKView) {
    
    layoutScene()
    saveStats()
    
  }
  
  func layoutScene() {
    
    let background = SKSpriteNode(imageNamed: "BG")
    background.posByCanvas(0.5, y: 0.5)
    background.xScale = 1.2
    background.yScale = 1.2
    background.zPosition = -1
    addChild(background)
    
    let nameBlock = SKLabelNode(fontNamed: "MarkerFelt-Wide")
    nameBlock.posByScreen(0.5, y: 0.5)
    nameBlock.fontColor = SKColor.whiteColor()
    nameBlock.fontSize = 64
    if (win != nil) {
    nameBlock.text = win! ? "You Passed!" : "You Failed!"
    }
    addChild(nameBlock)
    
  }
  
  func saveStats() {
    if win! {
      NSUserDefaults.standardUserDefaults().setBool(true, forKey: "Level_\(level!)")
      if gems! > NSUserDefaults.standardUserDefaults().integerForKey("\(level!)gems") {
        NSUserDefaults.standardUserDefaults().setInteger(gems!, forKey: "\(level!)gems")
      }
      NSUserDefaults.standardUserDefaults().synchronize()
    }
  }
  
  override func screenInteractionStarted(location: CGPoint) {
    
    let nextScene = MainMenu(size: self.scene!.size)
    nextScene.scaleMode = self.scaleMode
    self.view?.presentScene(nextScene)
    
  }
  #if !os(OSX)
  override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
    let nextScene = MainMenu(size: self.scene!.size)
    nextScene.scaleMode = self.scaleMode
    self.view?.presentScene(nextScene)
  }
  #endif
  
}