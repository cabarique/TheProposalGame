//
//  FinaleScene.swift
//  MyProposalGame
//
//  Created by Luis Cabarique on 11/28/16.
//  Copyright © 2016 Luis Cabarique. All rights reserved.
//

import SpriteKit

class FinaleScreen: SGScene {
    let sndButtonClick = SKAction.playSoundFileNamed("button_click.wav", waitForCompletion: false)
    
    var finaleScene:Int = 1
    var background: SKSpriteNode!
    
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
        
        background = SKSpriteNode(imageNamed: "FINALE_0\(finaleScene)")
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
                    nextGame(finaleScene)
                }
            }
        }
    }
    
    private func nextGame(index: Int){
        finaleScene = index + 1
        if finaleScene > 2 {
            let nextScene = LevelSelect(size: self.scene!.size)
            nextScene.scaleMode = self.scaleMode
            self.view?.presentScene(nextScene)
        }else{
            background.texture = SKTexture(imageNamed: "FINALE_0\(finaleScene)")
        }
        
    }
    
    
}
