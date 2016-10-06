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
    var coins: Int?
    
    private var coinCounter: SKLabelNode!
    private var endGame: SKSpriteNode!
    
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
        
        endGame = SKSpriteNode(imageNamed: "gameEnd")
        endGame.posByCanvas(0.5, y: 0.5)
        endGame.xScale = 0.8
        endGame.yScale = 0.8
        endGame.zPosition = 0
        
        let buttonScale: CGFloat = 0.62
        let buttonAtlas = SKTextureAtlas(named: "Button")
        
        let homeButton = SKSpriteNode(texture: buttonAtlas.textureNamed("home"))
        homeButton.zPosition = 10
        homeButton.setScale(buttonScale)
        homeButton.position = CGPoint(x: 0, y: ((-endGame.size.height/2) - (homeButton.size.height/2)) + 35)
        homeButton.name = "Home"
        endGame.addChild(homeButton)
        
        let restartButton = SKSpriteNode(texture: buttonAtlas.textureNamed("update"))
        restartButton.zPosition = 10
        restartButton.setScale(buttonScale)
        restartButton.position = CGPoint(x: -100, y: ((-endGame.size.height/2) - (homeButton.size.height/2)) + 35)
        restartButton.name = "Restart"
        endGame.addChild(restartButton)
        
        let nextButton = SKSpriteNode(texture: buttonAtlas.textureNamed("triangleR"))
        nextButton.zPosition = 10
        nextButton.setScale(buttonScale)
        nextButton.position = CGPoint(x: 100, y: ((-endGame.size.height/2) - (homeButton.size.height/2)) + 35)
        nextButton.name = "Next"
        endGame.addChild(nextButton)
        
        
        
        addChild(endGame)
        
        let coinCounter: SKLabelNode = SKLabelNode(fontNamed: GameSettings.standarFontName)
        coinCounter.fontSize = 55
        coinCounter.zPosition = 10
        coinCounter.position = CGPoint(x: 120, y: -163)
        coinCounter.text = String(format: "%04d", coins!)
        
        endGame.addChild(coinCounter)
        addDiamonds(diamonds!)
        
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
                    self.runAction(sndButtonClick)
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
    
    private func addDiamonds(diamonds: Int){
        let diamondTexture = SKTextureAtlas(named: "GUI").textureNamed("diamondBlue")
        if diamonds >= 1 {
            let diamond1: SKSpriteNode = SKSpriteNode(texture: diamondTexture)
            diamond1.zPosition = 10
            diamond1.position = CGPoint(x: -99, y: 24)
            diamond1.setScale(0.58)
            endGame.addChild(diamond1)
        }
        
        if diamonds >= 2 {
            let diamond2: SKSpriteNode = SKSpriteNode(texture: diamondTexture)
            diamond2.zPosition = 10
            diamond2.position = CGPoint(x: 106, y: 24)
            diamond2.setScale(0.58)
            endGame.addChild(diamond2)
        }
        
        if diamonds >= 3 {
            let diamond3: SKSpriteNode = SKSpriteNode(texture: diamondTexture)
            diamond3.zPosition = 10
            diamond3.position = CGPoint(x: 1, y: 83)
            diamond3.setScale(0.68)
            endGame.addChild(diamond3)
        }
    }
}
