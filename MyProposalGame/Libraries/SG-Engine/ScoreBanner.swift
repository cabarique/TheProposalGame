//
//  ScoreBanner.swift
//  MyProposalGame
//
//  Created by Luis Cabarique on 9/29/16.
//  Copyright © 2016 Luis Cabarique. All rights reserved.
//

import SpriteKit
import GameplayKit

class ScoreBanner: SKNode {
    var coinHolder = SKSpriteNode()
    var diamondHolder = SKSpriteNode()
    
    var zPos:CGFloat = 1000
    private var coins = 0{
        didSet{
            coinCounter.text = String(coins)
        }
    }
    private var diamonds = 0{
        didSet{
            diamondCounter.text = String(diamonds)
        }
    }
    
    private let coinCounter: SKLabelNode!
    private let diamondCounter: SKLabelNode!
    
    init(scoreName: String) {
        
        let atlas = SKTextureAtlas(named: "GUI")
        
        coinHolder = SKSpriteNode(texture: atlas.textureNamed("holderL"))
        coinHolder.zPosition = zPos
        coinHolder.size = CGSize(width: 136.79, height: 50)
        
        let coin = SKSpriteNode(texture: atlas.textureNamed("Coin"))
        coin.zPosition = zPos + 1
        coin.size = CGSize(width: 32, height: 30) //64x60
        coin.position = CGPoint(x: -44.7, y: 1.5)
        coinHolder.addChild(coin)
        
        coinCounter = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        coinCounter.fontSize = 30
        coinCounter.fontColor = SKColor.whiteColor()
        coinCounter.text = String(coins)
        coinCounter.zPosition = coinHolder.zPosition + 1
        coinCounter.position = CGPoint(x: 20, y: -12)
        coinHolder.addChild(coinCounter)
        
        diamondHolder = SKSpriteNode(texture: atlas.textureNamed("holderL"))
        diamondHolder.zPosition = zPos
        diamondHolder.size = CGSize(width: 136.79, height: 50)
        diamondHolder.position = CGPoint(x: 0, y: 55)
        
        let diamond = SKSpriteNode(texture: atlas.textureNamed("diamondBlue"))
        diamond.zPosition = zPos + 1
        diamond.size = CGSize(width: 35.25, height: 30) //161x137
        diamond.position = CGPoint(x: -44.7, y: 0)
        diamondHolder.addChild(diamond)
        
        diamondCounter = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        diamondCounter.zPosition = diamondHolder.zPosition + 1
        diamondCounter.fontSize = 30
        diamondCounter.fontColor = SKColor.whiteColor()
        diamondCounter.text = String(coins)
        diamondCounter.position = CGPoint(x: 20, y: -11)
        diamondHolder.addChild(diamondCounter)
        
        super.init()
        
        self.name = scoreName
        
        self.addChild(coinHolder)
        self.addChild(diamondHolder)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addCoint(){
        coins += 1
        print("add coin")
    }
    
    func addDiamond(){
        diamonds += 1
        print("add Diamond")
    }

}
