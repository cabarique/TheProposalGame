//
//  IntroScene.swift
//  MyProposalGame
//
//  Created by Luis Cabarique on 11/24/16.
//  Copyright © 2016 Luis Cabarique. All rights reserved.
//

import SpriteKit

class IntroScreen: SGScene {
    let sndButtonClick = SKAction.playSoundFileNamed("button_click.wav", waitForCompletion: false)
    
    var introScene:Int = 1
    var background: SKSpriteNode!
    
    private var endGame: SKSpriteNode!
    
    override func didMoveToView(view: SKView) {
        
        layoutScene()
        
    }
    
    func layoutScene() {
        
        let buttonScale: CGFloat = 0.62
        let buttonAtlas = SKTextureAtlas(named: "Button")
        
        let homeButton = SKSpriteNode(texture: buttonAtlas.textureNamed("arrowR"))
        homeButton.zPosition = 10
        homeButton.alpha = 0.7
        homeButton.setScale(buttonScale)
        homeButton.posByCanvas(0.9, y: 0.2)
        homeButton.name = "Next"
        addChild(homeButton)
        
        background = SKSpriteNode(imageNamed: "INTRO_0\(introScene)")
        background.posByCanvas(0.5, y: 0.5)
        background.setScale(0.8)
        background.zPosition = -1
        addChild(background)
        
    }
    
    override func screenInteractionStarted(location: CGPoint) {
        for node in nodesAtPoint(location) {
            if let theNode:SKNode = node,
                let nodeName = theNode.name {
                if nodeName == "Next"{
                    self.runAction(sndButtonClick)
                    nextGame(introScene)
                }
            }
        }
    }
    
    private func nextGame(index: Int){
        introScene = index + 1
        if introScene > 4 {
            let nextScene = GamePlayMode(size: self.scene!.size)
            nextScene.levelIndex = 0
            nextScene.scaleMode = self.scaleMode
            self.view?.presentScene(nextScene)
        }else{
            background.texture = SKTexture(imageNamed: "INTRO_0\(introScene)")
        }
        
    }
    
    
}
