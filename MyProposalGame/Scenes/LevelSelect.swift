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

class LevelSelect: SGScene {
    
    //Sounds
    let sndButtonClick = SKAction.playSoundFileNamed("button_click.wav", waitForCompletion: false)
    
    var characterIndex = 0
    
    let levelLayer = SKNode()
    
    override func didMoveToView(view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "BG")
        background.posByCanvas(0.5, y: 0.5)
        background.xScale = 1.2
        background.yScale = 1.2
        background.zPosition = -1
        addChild(background)
        
        let levelSelector = SKSpriteNode(imageNamed: "level")
        levelSelector.posByCanvas(0.5, y: 0.5)
        levelSelector.xScale = 0.7
        levelSelector.yScale = 0.7
        levelSelector.zPosition = 0
        
        let buttonAtlas = SKTextureAtlas(named: "Button")
        let homeButton = SKSpriteNode(texture: buttonAtlas.textureNamed("home"))
        homeButton.zPosition = 10
        homeButton.setScale(0.75)
        homeButton.position = CGPoint(x: 0, y: ((-levelSelector.size.height/2) - (homeButton.size.height/2)) + 20)
        homeButton.name = "Home"
        levelSelector.addChild(homeButton)
        
        addChild(levelSelector)
        
        //Next and previous page
        
        
        //Show levels
        showLevelsFrom(0)
        
    }
    
    func showLevelsFrom(index:Int) {
        
        for node in levelLayer.children {
            node.removeFromParent()
        }
        
        let gridSize = CGSize(width: 3, height: 2)
        let gridSpacing = CGSize(width: 130, height: -120)
        let gridStart = CGPoint(screenX: 0.31, screenY: 0.65)
        //var gridIndex = 0
        
        var currentX = 0
        var currentY = 0
        var lastAvail = false
        
        let guiAtlas = SKTextureAtlas(named: "GUI")
        
        for (index, _) in tileMapLevels.MainSet.enumerate() {
            
            var available:Bool
            if index != 0 {
                available = NSUserDefaults.standardUserDefaults().boolForKey("Level_\(index)")
            } else {
                available = true
            }
            
            
            let sign = SKSpriteNode(texture: guiAtlas.textureNamed("levelButton"))
            sign.position = CGPoint(x: gridStart.x + (gridSpacing.width * CGFloat(currentX)), y: gridStart.y + (gridSpacing.height * CGFloat(currentY)))
            sign.size = CGSize(width: 101, height: 128)
            sign.zPosition = 20
            sign.userData = ["Index":index,"Available":(available || lastAvail)]
            sign.name = "LevelSign"
            addChild(sign)
            
            let signText = SKLabelNode(fontNamed: GameSettings.standarFontName)
            signText.position = sign.position
            signText.fontColor = SKColor.whiteColor()
            signText.fontSize = 60
            signText.zPosition = 21
            signText.text = (available || lastAvail) ? "\(index + 1)" : "X"
            addChild(signText)
            
            let diamons = NSUserDefaults.standardUserDefaults().integerForKey("\(index)diamonds") as Int
            let diamondStart = [CGPoint(x: (6 - (sign.size.width / 3) + ((sign.size.width / 3) * CGFloat(0))) as CGFloat, y: -(sign.size.height / 3.2)),
                                CGPoint(x: (-(sign.size.width / 3) + ((sign.size.width / 3) * CGFloat(1))) as CGFloat, y: -(sign.size.height / 3.2)),
                                CGPoint(x: (-8 - (sign.size.width / 3) + ((sign.size.width / 3) * CGFloat(2))) as CGFloat, y: -(sign.size.height / 3.2))]
            for i in 0..<diamons {
                let gem = SKSpriteNode(texture: guiAtlas.textureNamed("diamondBlue"))
                gem.size = CGSize(width: 24, height: 20)
                gem.position = diamondStart[i]
                gem.zPosition = 22
                sign.addChild(gem)
            }
            
            currentX += 1
            if currentX > Int(gridSize.width) {
                currentX = 0
                currentY += 1
            }
            if available {
                if index == 0 && NSUserDefaults.standardUserDefaults().boolForKey("Level_\(index)") != true{
                    lastAvail = false
                }else{
                    lastAvail = true
                }
            } else {
                lastAvail = false
            }
            
        }
        
    }
    
    override func screenInteractionStarted(location: CGPoint) {
        for node in nodesAtPoint(location) {
            if let theNode:SKNode = node,
                let nodeName = theNode.name {
                if nodeName == "Home"{
                    let nextScene = GameScene(size: self.scene!.size)
                    nextScene.scaleMode = self.scaleMode
                    self.view?.presentScene(nextScene)
                }else if nodeName == "LevelSign" {
                    if theNode.userData!["Available"] as! Bool == true {
                        self.runAction(sndButtonClick)
                        let nextScene = GamePlayMode(size: self.scene!.size)
                        nextScene.levelIndex = (theNode.userData!["Index"] as? Int)!
                        nextScene.scaleMode = self.scaleMode
                        self.view?.presentScene(nextScene)
                    }
                }
            }
        }
    }
    
}
