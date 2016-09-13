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
#if os(OSX)
  import AppKit
#endif

class MainMenu: SGScene {
  
  //Sounds
  let sndTitleDrop = SKAction.playSoundFileNamed("title_drop.wav", waitForCompletion: false)
  let sndButtonClick = SKAction.playSoundFileNamed("button_click.wav", waitForCompletion: false)
  
  override func didMoveToView(view: SKView) {
    
    let background = SKSpriteNode(imageNamed: "BG")
    background.posByCanvas(0.5, y: 0.5)
    background.xScale = 1.2
    background.yScale = 1.2
    background.zPosition = -1
    addChild(background)
    
    let playButton = SKLabelNode(fontNamed: "MarkerFelt-Wide")
    playButton.posByScreen(0.5, y: 0.3)
    playButton.fontSize = 56
    playButton.text = lt("Enter")
    playButton.fontColor = SKColor.whiteColor()
    playButton.zPosition = 10
    playButton.name = "playGame"
    addChild(playButton)
    
    //For debugging
    
    let buildButton = SKLabelNode(fontNamed: "MarkerFelt-Wide")
    buildButton.posByScreen(0.5, y: 0.2)
    buildButton.fontSize = 56
    buildButton.text = lt("Build")
    buildButton.fontColor = SKColor.whiteColor()
    buildButton.zPosition = 10
    buildButton.name = "buildGame"
    addChild(buildButton)
    
    let title = SKSpriteNode(imageNamed: "TOTSG01")
    title.posByCanvas(0.5, y: 1.5)
    title.xScale = 0.5
    title.yScale = 0.5
    title.zPosition = 15
    addChild(title)
    title.runAction(SKAction.sequence([
      SKAction.moveTo(CGPoint(screenX: 0.5, screenY: 0.7), duration: 1.2),
      sndTitleDrop
      ]))
    
    #if os(OSX)
      let exitButton = SKLabelNode(fontNamed: "MarkerFelt-Wide")
      exitButton.posByScreen(0.5, y: 0.1)
      exitButton.fontSize = 56
      exitButton.text = lt("Exit")
      exitButton.fontColor = SKColor.whiteColor()
      exitButton.zPosition = 10
      exitButton.name = "exitGame"
      addChild(exitButton)
    #endif
    
  }
  
  //MARK: Responders
  
  override func screenInteractionStarted(location: CGPoint) {
    
    for node in nodesAtPoint(location) {
      if node.isKindOfClass(SKNode) {
        
        if node.name == "playGame" {
          buttonEvent("buttonA", velocity: 1.0, pushedOn: true)
        }
        
        if node.name == "buildGame" {
          buttonEvent("buttonB", velocity: 1.0, pushedOn: true)
        }
        
        #if os(OSX)
        if node.name == "exitGame" {
          self.runAction(sndButtonClick)
          NSApplication.sharedApplication().terminate(self)
        }
        #endif
        
      }
    }
    
  }
  
  override func buttonEvent(event:String,velocity:Float,pushedOn:Bool) {
    if event == "buttonA" {
      
      self.runAction(sndButtonClick)
      
      let nextScene = CharSelect(size: self.scene!.size)
      nextScene.scaleMode = self.scaleMode
      self.view?.presentScene(nextScene)
      
    }
    if event == "buttonB" {
      
      self.runAction(sndButtonClick)
      
      let nextScene = GameBuildMode(size: self.scene!.size)
      nextScene.scaleMode = self.scaleMode
      self.view?.presentScene(nextScene)
      
    }
    
  }
  
  override func stickEvent(event:String,point:CGPoint) {
    
  }
  #if !os(OSX)
  override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
    self.runAction(sndButtonClick)
    
    let nextScene = CharSelect(size: self.scene!.size)
    nextScene.scaleMode = self.scaleMode
    self.view?.presentScene(nextScene)
  }
  #endif
}
