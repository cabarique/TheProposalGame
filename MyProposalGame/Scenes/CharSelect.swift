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

class CharSelect: SGScene {
  
  //Sounds
  let sndButtonClick = SKAction.playSoundFileNamed("button_click.wav", waitForCompletion: false)
  
  override func didMoveToView(view: SKView) {
    
    let background = SKSpriteNode(imageNamed: "BG")
    background.posByCanvas(0.5, y: 0.5)
    background.xScale = 1.2
    background.yScale = 1.2
    background.zPosition = -1
    addChild(background)
    
    let nameBlock = SKLabelNode(fontNamed: "MarkerFelt-Wide")
    nameBlock.posByScreen(0.5, y: 0.9)
    nameBlock.fontColor = SKColor.whiteColor()
    nameBlock.fontSize = 54
    nameBlock.text = "Select a Character:"
    addChild(nameBlock)
    
    //Characters
    
    let characters = ["Male","Female"]
    let count = characters.count
    
    for (index, char) in characters.enumerate() {
      let atlas = SKTextureAtlas(named: char)
      
      let charNode = SKSpriteNode(texture: atlas.textureNamed("Idle__000"))
      let locX:Double = (1.0 / Double(count + 1))
      let location = locX + (locX * Double(index))
      charNode.posByScreen(CGFloat(location), y: 0.5)
      charNode.size = CGSize(width: 232, height: 439)
      charNode.xScale = 0.5
      charNode.yScale = 0.5
      charNode.name = "C\(index)"
      charNode.userData = ["Index":index]
      addChild(charNode)
      
      let nameBlock = SKLabelNode(fontNamed: "MarkerFelt-Wide")
      nameBlock.posByScreen(CGFloat(location), y: 0.25)
      nameBlock.fontColor = SKColor.whiteColor()
      nameBlock.fontSize = 32
      nameBlock.text = char
      addChild(nameBlock)
      
    }
    
  }
  
  override func screenInteractionStarted(location: CGPoint) {
    for node in nodesAtPoint(location) {
      if let nodename = node.name {
        if nodename.hasPrefix("C") {
          self.runAction(sndButtonClick)
          let nextScene = LevelSelect(size: self.scene!.size)
          nextScene.characterIndex = node.userData!["Index"] as! Int
          nextScene.scaleMode = self.scaleMode
          self.view?.presentScene(nextScene)
        }
      }
    }
  }

}

