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
    
    let playButton = SKLabelNode(fontNamed: GameSettings.standarFontName)
    playButton.posByScreen(0.5, y: 0.3)
    playButton.fontSize = 70
    playButton.text = lt("Jugar")
    playButton.fontColor = SKColor.blackColor()
    playButton.zPosition = 10
    playButton.name = "playGame"
    
    let dropShadowPlay = SKLabelNode(fontNamed: GameSettings.standarFontName)
    dropShadowPlay.fontSize = playButton.fontSize
    dropShadowPlay.fontColor = SKColor.whiteColor()
    dropShadowPlay.text = playButton.text
    dropShadowPlay.zPosition = playButton.zPosition + 1
    dropShadowPlay.position = CGPointMake(dropShadowPlay.position.x - 2, dropShadowPlay.position.y - 2)
    playButton.addChild(dropShadowPlay)
    addChild(playButton)
    
    //For debugging
    
    let buildButton = SKLabelNode(fontNamed: GameSettings.standarFontName)
    buildButton.posByScreen(0.5, y: 0.2)
    buildButton.fontSize = 60
    buildButton.text = lt("Constructor")
    buildButton.fontColor = SKColor.blackColor()
    buildButton.zPosition = 10
    buildButton.name = "buildGame"
    
    let dropShadow = SKLabelNode(fontNamed: GameSettings.standarFontName)
    dropShadow.fontSize = buildButton.fontSize
    dropShadow.fontColor = SKColor.whiteColor()
    dropShadow.text = buildButton.text
    dropShadow.zPosition = buildButton.zPosition + 1
    dropShadow.position = CGPointMake(dropShadow.position.x - 2, dropShadow.position.y - 2)
    buildButton.addChild(dropShadow)
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
        
      }
    }
    
  }
  
  override func buttonEvent(event:String,velocity:Float,pushedOn:Bool) {
    if event == "buttonA" {
      
      self.runAction(sndButtonClick)
      
      let nextScene = LevelSelect(size: self.scene!.size)
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
}
