//
//  CreditsScene.swift
//  MyProposalGame
//
//  Created by Luis Cabarique on 11/29/16.
//  Copyright © 2016 Luis Cabarique. All rights reserved.
//

import SpriteKit

class CreditsScreen: SGScene {
    let sndButtonClick = SKAction.playSoundFileNamed("button_click.wav", waitForCompletion: false)
    
    var finaleScene:Int = 1
    var background: SKSpriteNode!
    var textField: UITextView!
    
    override func didMoveToView(view: SKView) {
        
        layoutScene()
        
    }
    
    
    
    func layoutScene() {
        
        let buttonScale: CGFloat = 0.62
        let buttonAtlas = SKTextureAtlas(named: "Button")
        
        let homeButton = SKSpriteNode(texture: buttonAtlas.textureNamed("home"))
        homeButton.zPosition = 10
        homeButton.alpha = 0.7
        homeButton.setScale(buttonScale)
        homeButton.posByCanvas(0.9, y: 0.2)
        homeButton.name = "Next"
        addChild(homeButton)
        
        background = SKSpriteNode(color: SKColor.blackColor(), size: CGSizeZero)
        background.posByCanvas(0.5, y: 0.5)
        background.zPosition = -1
        addChild(background)
        
        textField = UITextView(frame: CGRect(x: 20, y: 20, width: view!.frame.size.width - 40, height: view!.frame.size.height - 150))
        textField.textColor = SKColor.whiteColor()
        textField.editable = false
        textField.backgroundColor = SKColor.clearColor()
        textField.font = UIFont(name: GameSettings.standarFontName, size: 30)
        textField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        let attributedString = NSMutableAttributedString(string: "Este juego esta dedicado para la mujer de mi vida, Anamaria Parra. Espero que te guste y te diviertas matando zombies y criaturas. :) \n\n\n Att. Luis Cabarique")
        attributedString.addAttributes([
            NSKernAttributeName: CGFloat(1.4),
            NSFontAttributeName: UIFont(name: GameSettings.standarFontName, size: 30)!,
            NSForegroundColorAttributeName: SKColor.whiteColor()
            ], range: NSRange(location: 0, length: 157))
        
        textField.attributedText = attributedString
        view?.addSubview(textField)
        
    }
    
    override func screenInteractionStarted(location: CGPoint) {
        for node in nodesAtPoint(location) {
            if let theNode:SKNode = node,
                let nodeName = theNode.name {
                if nodeName == "Next"{
                    let nextScene = MainMenu(size: self.scene!.size)
                    nextScene.scaleMode = self.scaleMode
                    textField.removeFromSuperview()
                    self.view?.presentScene(nextScene)
                }
            }
        }
    }
    
    
    
    
}

