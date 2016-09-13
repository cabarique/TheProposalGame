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
    gs.physicsWorld.gravity = CGVector(dx: 0.0, dy: -1.0)
    
    //Camera
    let myCamera = SKCameraNode()
    gs.camera = myCamera
    gs.addChild(myCamera)
    gs.camera?.setScale(0.44)
    
    //Layers
    gs.worldLayer = TileLayer(levelIndex: gs.levelIndex, typeIndex: .setMain)
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
    let characters = ["Male","Female"]
    let atlas = SKTextureAtlas(named: characters[gs.characterIndex])
    
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
    
    gs.worldLayer.enumerateChildNodesWithName("placeholder_FinishPoint") { (node, stop) -> Void in
      let finish = FinishEntity(position: node.position, size: CGSize(width: 32, height: 32), texture: SKTexture())
      self.gs.addEntity(finish, toLayer: self.gs.worldLayer)
    }
    
    let tileAtlas = SKTextureAtlas(named: "Tiles")
    gs.worldLayer.enumerateChildNodesWithName("placeholder_Gem") { (node, stop) -> Void in
      let gem = GemEntity(position: node.position, size: CGSize(width: 32, height: 32), texture: tileAtlas.textureNamed("gem"))
      gem.spriteComponent.node.zPosition = GameSettings.GameParams.zValues.zWorldFront
      self.gs.addEntity(gem, toLayer: self.gs.worldLayer)
    }
    
    
    //Setup UI
    let pauseButton = SKLabelNode(fontNamed: "MarkerFelt-Wide")
    pauseButton.posByScreen(0.46, y: 0.42)
    pauseButton.fontSize = 40
    pauseButton.text = gs.lt("II")
    pauseButton.fontColor = SKColor.whiteColor()
    pauseButton.zPosition = 150
    pauseButton.name = "PauseButton"
    gs.overlayGUI.addChild(pauseButton)
    
    gs.movementStick.position = CGPoint(x: -((gs.overlayGUI.scene?.size.width)!/3), y: -70)
    gs.overlayGUI.addChild(gs.movementStick)
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
    nextScene.gems = gs.gemsCollected
    nextScene.scaleMode = gs.scaleMode
    gs.view?.presentScene(nextScene)
  }
}
class GameSceneLoseState: GameSceneState {
  override func didEnterWithPreviousState(previousState: GKState?) {
    let nextScene = PostScreen(size: gs.scene!.size)
    nextScene.level = gs.levelIndex
    nextScene.win = false
    nextScene.gems = gs.gemsCollected
    nextScene.scaleMode = gs.scaleMode
    gs.view?.presentScene(nextScene)
  }
}
