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
import GameplayKit
import SpriteKit

class GameSceneState: GKState {
    unowned let gs: GamePlayMode
    init(scene: GamePlayMode) {
        self.gs = scene
    }
}

class GameSceneInitialState: GameSceneState {
    override func didEnterWithPreviousState(previousState: GKState?) {
        
        //Delegates
        gs.physicsWorld.contactDelegate = gs
        gs.physicsWorld.gravity = CGVectorMake(0.0, -1.8)
        
        //Camera
        let myCamera = SKCameraNode()
        gs.camera = myCamera
        gs.addChild(myCamera)
        gs.camera?.setScale(0.44)
        
        //Layers
        switch gs.levelIndex{
        case 0:
           gs.worldLayer = TileLayer1(levelIndex: gs.levelIndex, typeIndex: .setMain)
        case 1:
            gs.worldLayer = TileLayer3(levelIndex: gs.levelIndex, typeIndex: .setMain)
        case 2:
            gs.worldLayer = TileLayer3(levelIndex: gs.levelIndex, typeIndex: .setMain)
        case 3:
            gs.worldLayer = TileLayer2(levelIndex: gs.levelIndex, typeIndex: .setMain)
        default:
            gs.worldLayer = TileLayer1(levelIndex: gs.levelIndex, typeIndex: .setMain)
        }
        
        gs.backgroundLayer = SKNode()
        gs.overlayGUI = SKNode()
        gs.addChild(gs.worldLayer)
        myCamera.addChild(gs.backgroundLayer)
        myCamera.addChild(gs.overlayGUI)
        
        //Initial Entities
        let background01 = BackgroundEntity(movementFactor: CGPoint(x: -0.33, y: 0.0), image: SKTexture(imageNamed: "BG001") , size: SKMSceneSize!, position:CGPointZero, reset: true)
        background01.spriteComponent.node.zPosition = GameSettings.GameParams.zValues.zBackground01
        gs.addEntity(background01, toLayer:gs.backgroundLayer)
        let background02 = BackgroundEntity(movementFactor: CGPoint(x: -0.33, y: 0.0), image: SKTexture(imageNamed: "BG001") , size: SKMSceneSize!, position:CGPoint(x: SKMSceneSize!.width, y: 0), reset: true)
        background02.spriteComponent.node.zPosition = GameSettings.GameParams.zValues.zBackground01
        gs.addEntity(background02, toLayer:gs.backgroundLayer)
        let background03 = BackgroundEntity(movementFactor: CGPoint(x: -0.66, y: 0.0), image: SKTexture(imageNamed: "BG002") , size: SKMSceneSize!, position:CGPointZero, reset: true)
        background03.spriteComponent.node.zPosition = GameSettings.GameParams.zValues.zBackground02
        gs.addEntity(background03, toLayer:gs.backgroundLayer)
        let background04 = BackgroundEntity(movementFactor: CGPoint(x: -0.66, y: 0.0), image: SKTexture(imageNamed: "BG002") , size: SKMSceneSize!, position:CGPoint(x: SKMSceneSize!.width, y: 0), reset: true)
        background04.spriteComponent.node.zPosition = GameSettings.GameParams.zValues.zBackground02
        gs.addEntity(background04, toLayer:gs.backgroundLayer)
        let background05 = BackgroundEntity(movementFactor: CGPoint(x: -1.00, y: 0.0), image: SKTexture(imageNamed: "BG003") , size: SKMSceneSize!, position:CGPointZero, reset: true)
        background05.spriteComponent.node.zPosition = GameSettings.GameParams.zValues.zBackground03
        gs.addEntity(background05, toLayer:gs.backgroundLayer)
        let background06 = BackgroundEntity(movementFactor: CGPoint(x: -1.00, y: 0.0), image: SKTexture(imageNamed: "BG003") , size: SKMSceneSize!, position:CGPoint(x: SKMSceneSize!.width, y: 0), reset: true)
        background06.spriteComponent.node.zPosition = GameSettings.GameParams.zValues.zBackground03
        gs.addEntity(background06, toLayer:gs.backgroundLayer)
        
        //Add nodes for placeholders
        let atlas = SKTextureAtlas(named: "Cat")
        if let playerPlaceholder = gs.worldLayer.childNodeWithName("placeholder_StartPoint") {
            let player = PlayerEntity(position: playerPlaceholder.position, size: CGSize(width: 25.4, height: 48.0), firstFrame: atlas.textureNamed("Idle__000"), atlas: atlas, scene:gs)
            player.spriteComponent.node.anchorPoint = CGPoint(x: 0.5, y: 0.0)
            player.spriteComponent.node.zPosition = GameSettings.GameParams.zValues.zPlayer
            player.animationComponent.requestedAnimationState = .Idle
            gs.centerCameraOnPoint(playerPlaceholder.position)
            gs.addEntity(player, toLayer: gs.worldLayer)
            gs.worldFrame = gs.worldLayer.calculateAccumulatedFrame()
            gs.setCameraConstraints()
        } else {
            fatalError("[Play Mode: No placeholder for player!")
        }
        
        let princessTexture = SKTextureAtlas(named: "Princess")
        gs.worldLayer.enumerateChildNodesWithName("placeholder_Princess") { (node, stop) in
            let princess = PrincessEntity(position: node.position, size: CGSize(width: 25.4, height: 48.0), atlas: princessTexture, scene: self.gs, name: "Princess")
            princess.spriteComponent.node.anchorPoint = CGPoint(x: 0.5, y: 0.0)
            princess.spriteComponent.node.zPosition = GameSettings.GameParams.zValues.zPlayer - 1
            self.gs.addEntity(princess, toLayer: self.gs.worldLayer)
        }
        
        //Enemies
        let enemies = ["Zombie1", "Zombie2", "Mage1", "Mage2", "Boss"]
        let enemy1Atlas = SKTextureAtlas(named: enemies[0])
        gs.worldLayer.enumerateChildNodesWithName("placeholder_\(enemies[0])") { (node, stop) in
            let zombie = EnemyEntity(position: node.position, size: CGSize(width: 25.4, height: 48.0), atlas: enemy1Atlas, scene: self.gs, name: enemies[0])
            zombie.spriteComponent.node.anchorPoint = CGPoint(x: 0.5, y: 0.0)
            zombie.spriteComponent.node.zPosition = GameSettings.GameParams.zValues.zPlayer - 1
            self.gs.addEntity(zombie, toLayer: self.gs.worldLayer)
        }
        
        let enemy2Atlas = SKTextureAtlas(named: enemies[1])
        gs.worldLayer.enumerateChildNodesWithName("placeholder_\(enemies[1])") { (node, stop) in
            let zombie = EnemyEntity(position: node.position, size: CGSize(width: 25.4, height: 48.0), atlas: enemy2Atlas, scene: self.gs, name: enemies[1])
            zombie.spriteComponent.node.anchorPoint = CGPoint(x: 0.5, y: 0.0)
            zombie.spriteComponent.node.zPosition = GameSettings.GameParams.zValues.zPlayer - 1
            self.gs.addEntity(zombie, toLayer: self.gs.worldLayer)
        }
        
        let mage1Atlas = SKTextureAtlas(named: enemies[2])
        gs.worldLayer.enumerateChildNodesWithName("placeholder_\(enemies[2])") { (node, stop) in
            let mage = Mage1Entity(position: node.position, size: CGSize(width: 25.4, height: 48.0), atlas: mage1Atlas, scene: self.gs, name: enemies[2])
            mage.spriteComponent.node.anchorPoint = CGPoint(x: 0.5, y: 0.0)
            mage.spriteComponent.node.zPosition = GameSettings.GameParams.zValues.zPlayer - 1
            self.gs.addEntity(mage, toLayer: self.gs.worldLayer)
        }
        
        let mage2Atlas = SKTextureAtlas(named: enemies[3])
        gs.worldLayer.enumerateChildNodesWithName("placeholder_\(enemies[3])") { (node, stop) in
            let mage = Mage2Entity(position: node.position, size: CGSize(width: 25.4, height: 48.0), atlas: mage2Atlas, scene: self.gs, name: enemies[3])
            mage.spriteComponent.node.anchorPoint = CGPoint(x: 0.5, y: 0.0)
            mage.spriteComponent.node.zPosition = GameSettings.GameParams.zValues.zPlayer - 1
            self.gs.addEntity(mage, toLayer: self.gs.worldLayer)
        }
        
        let bossAtlas = SKTextureAtlas(named: enemies[4])
        gs.worldLayer.enumerateChildNodesWithName("placeholder_\(enemies[4])") { (node, stop) in
            let boss = BossEntity(position: node.position, size: CGSize(width: 25.4, height: 48.0), atlas: bossAtlas, scene: self.gs, name: enemies[4])
            boss.spriteComponent.node.anchorPoint = CGPoint(x: 0.5, y: 0.0)
            boss.spriteComponent.node.zPosition = GameSettings.GameParams.zValues.zPlayer - 1
            self.gs.addEntity(boss, toLayer: self.gs.worldLayer)
        }
        
        gs.worldLayer.enumerateChildNodesWithName("placeholder_FinishPoint") { (node, stop) -> Void in
            let finish = FinishEntity(position: node.position, size: CGSize(width: 32, height: 32), texture: SKTexture())
            self.gs.addEntity(finish, toLayer: self.gs.worldLayer)
        }
        
        let GUIAtlas = SKTextureAtlas(named: "GUI")
        gs.worldLayer.enumerateChildNodesWithName("placeholder_Diamond") { (node, stop) -> Void in
            let diamond = GemEntity(position: node.position, size: CGSize(width: 32, height: 29), texture: GUIAtlas.textureNamed("diamondBlue"))
            diamond.spriteComponent.node.zPosition = GameSettings.GameParams.zValues.zWorldFront
            self.gs.addEntity(diamond, toLayer: self.gs.worldLayer)
        }
        
        gs.worldLayer.enumerateChildNodesWithName("placeholder_Coin") { (node, stop) -> Void in
            let coin = CoinEntity(position: node.position, size: CGSize(width: 20, height: 20), texture: GUIAtlas.textureNamed("Coin"))
            coin.spriteComponent.node.zPosition = GameSettings.GameParams.zValues.zWorldFront
            self.gs.addEntity(coin, toLayer: self.gs.worldLayer)
        }
        
        
        //Setup UI
        let buttonAtlas = SKTextureAtlas(named: "Button")
        let pauseButton = SKSpriteNode(texture: buttonAtlas.textureNamed("Pause"))
        pauseButton.posByScreen(0.45, y: 0.24)
        pauseButton.size = CGSize(width: 68.18, height: 70)//150x154
        pauseButton.zPosition = 150
        pauseButton.name = "PauseButton"
        gs.overlayGUI.addChild(pauseButton)
        
        gs.scoreBanner.posByScreen(-0.40, y: 0.18)
        gs.overlayGUI.addChild(gs.scoreBanner)
        
        //Controls
        gs.movementStick.posByScreen(-0.40, y: -0.49)
        gs.overlayGUI.addChild(gs.movementStick)
        
        gs.jumpButton.posByScreen(0.42, y: -0.52)
        gs.overlayGUI.addChild(gs.jumpButton)
        
        gs.fireButton.posByScreen(0.3, y: -0.52)
        gs.overlayGUI.addChild(gs.fireButton)
        
        gs.stateMachine.enterState(GameSceneActiveState.self)
    }
    
}
class GameSceneActiveState: GameSceneState {
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        
    }
    
}
class GameScenePausedState: GameSceneState {
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        gs.paused = true
        gs.pauseLoop = true
    }
    
    override func willExitWithNextState(nextState: GKState) {
        gs.paused = false
        gs.pauseLoop = false
    }
    
}
class GameSceneVictorySeqState: GameSceneState {
    
}
class GameSceneWinState: GameSceneState {
    override func didEnterWithPreviousState(previousState: GKState?) {
        let nextScene = PostScreen(size: gs.scene!.size)
        nextScene.level = gs.levelIndex
        nextScene.win = true
        nextScene.diamonds = gs.diamondsCollected
        nextScene.coins = gs.coinsCollected
        nextScene.scaleMode = gs.scaleMode
        gs.view?.presentScene(nextScene)
    }
}
class GameSceneLoseState: GameSceneState {
    override func didEnterWithPreviousState(previousState: GKState?) {
        let nextScene = PostScreen(size: gs.scene!.size)
        nextScene.level = gs.levelIndex
        nextScene.win = false
        nextScene.diamonds = gs.diamondsCollected
        nextScene.scaleMode = gs.scaleMode
        nextScene.coins = gs.coinsCollected
        gs.view?.presentScene(nextScene)
    }
}
