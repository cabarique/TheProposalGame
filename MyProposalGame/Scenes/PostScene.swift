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
    
    let sndButtonClick = SKAction.playSoundFileNamed("button_click.wav", waitForCompletion: false)
    
    var level:Int?
    var win:Bool?
    var diamonds:Int?
    
    override func didMoveToView(view: SKView) {
        
        layoutScene()
        saveStats()
        
    }
    
    func layoutScene() {
        
        if !win! {
            nextGame(level!)
            return
        }
        
        let background = SKSpriteNode(imageNamed: "BG")
        background.posByCanvas(0.5, y: 0.5)
        background.xScale = 1.2
        background.yScale = 1.2
        background.zPosition = -1
        addChild(background)
        
        let levelSelector = SKSpriteNode(imageNamed: "gameEnd")
        levelSelector.posByCanvas(0.5, y: 0.5)
        levelSelector.xScale = 0.8
        levelSelector.yScale = 0.8
        levelSelector.zPosition = 0
        
        let buttonScale: CGFloat = 0.62
        let buttonAtlas = SKTextureAtlas(named: "Button")
        
        let homeButton = SKSpriteNode(texture: buttonAtlas.textureNamed("home"))
        homeButton.zPosition = 10
        homeButton.setScale(buttonScale)
        homeButton.position = CGPoint(x: 0, y: ((-levelSelector.size.height/2) - (homeButton.size.height/2)) + 35)
        homeButton.name = "Home"
        levelSelector.addChild(homeButton)
        
        let restartButton = SKSpriteNode(texture: buttonAtlas.textureNamed("update"))
        restartButton.zPosition = 10
        restartButton.setScale(buttonScale)
        restartButton.position = CGPoint(x: -100, y: ((-levelSelector.size.height/2) - (homeButton.size.height/2)) + 35)
        restartButton.name = "Restart"
        levelSelector.addChild(restartButton)
        
        let nextButton = SKSpriteNode(texture: buttonAtlas.textureNamed("triangleR"))
        nextButton.zPosition = 10
        nextButton.setScale(buttonScale)
        nextButton.position = CGPoint(x: 100, y: ((-levelSelector.size.height/2) - (homeButton.size.height/2)) + 35)
        nextButton.name = "Next"
        levelSelector.addChild(nextButton)
        
        addChild(levelSelector)
        
    }
    
    func saveStats() {
        if win! {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "Level_\(level!)")
            if diamonds! > NSUserDefaults.standardUserDefaults().integerForKey("\(level!)diamonds") {
                NSUserDefaults.standardUserDefaults().setInteger(diamonds!, forKey: "\(level!)diamonds")
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
                }else if nodeName == "Restart"{
                    self.runAction(sndButtonClick)
                    nextGame(level!)
                }else if nodeName == "Next" {
                    self.runAction(sndButtonClick)
                    nextGame(level! + 1)
                }
            }
        }
    }
    
    private func nextGame(index: Int){
        let nextScene = GamePlayMode(size: self.scene!.size)
        nextScene.levelIndex = index
        nextScene.scaleMode = self.scaleMode
        self.view?.presentScene(nextScene)
    }
}
