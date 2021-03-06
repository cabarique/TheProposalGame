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
import GameplayKit



class GamePlayMode: SGScene, SKPhysicsContactDelegate {
    
    //MARK: Instance Variables
    
    //Initial Data
    var levelIndex = 0
    
    //Level Data
    var diamondsCollected = 0{
        didSet{
            scoreBanner.addDiamond()
        }
    }
    var coinsCollected = 0{
        didSet{
            scoreBanner.addCoint()
        }
    }
    var worldFrame = CGRect()
    
    //Layers
    var worldLayer:TileLayer!
    var backgroundLayer:SKNode!
    var overlayGUI:SKNode!
    
    //State Machine
    lazy var stateMachine: GKStateMachine = GKStateMachine(states: [
        GameSceneInitialState(scene: self),
        GameSceneActiveState(scene: self),
        GameScenePausedState(scene: self),
        GameSceneVictorySeqState(scene: self),
        GameSceneWinState(scene: self),
        GameSceneLoseState(scene: self)
        ])
    
    //ECS
    var entities = Set<GKEntity>()
    
    //Component systems
    lazy var componentSystems: [GKComponentSystem] = {
        let parallaxSystem = GKComponentSystem(componentClass: ParallaxComponent.self)
        let animationSystem = GKComponentSystem(componentClass: AnimationComponent.self)
        return [animationSystem, parallaxSystem]
    }()
    let enemySystem = EnemyControlComponentSystem(componentClass: EnemyMovementComponent.self)
    let mageSystem = MageControlComponentSystem(componentClass: MageMovementComponent.self)
    let scrollerSystem = FullControlComponentSystem(componentClass: FullControlComponent.self)
    
    //Timers
    var lastUpdateTimeInterval: NSTimeInterval = 0
    let maximumUpdateDeltaTime: NSTimeInterval = 1.0 / 60.0
    var lastDeltaTime: NSTimeInterval = 0
    
    //Controls
    var control = FullMoveControlScheme()
    var enemyControl = EnemyMoveControlScheme()
    var mageControl = MageMoveControlScheme()
    var pauseLoop = false
    let movementStick = MovementStick(stickName: "MoveStick")
    let jumpButton = JumpButton(buttonName: "JumpButton")
    let fireButton = FireButton(buttonName: "FireButton")
    var displayFinale = false
    
    //Scores
    let scoreBanner = ScoreBanner(scoreName: "ScoreBanner")
    
    //Sounds
    let sndCollectGood = SKAction.playSoundFileNamed("collect_good.wav", waitForCompletion: false)
    let sndJump = SKAction.playSoundFileNamed("jump.wav", waitForCompletion: false)
    let sndFirePew = SKAction.playSoundFileNamed("gun-pew.wav", waitForCompletion: false)
    let sndFire = SKAction.playSoundFileNamed("pew.wav", waitForCompletion: false)
    let sndDead = SKAction.playSoundFileNamed("game_over.wav", waitForCompletion: false)
    let sndMeow = SKAction.playSoundFileNamed("meow.mp3", waitForCompletion: false)
    let sndMeow2 = SKAction.playSoundFileNamed("meow", atVolume: 0.8, waitForCompletion: false, withExtension: ".mp3")
    let sndFinale = SKAction.playSoundFileNamed("meowSong.wav", waitForCompletion: false)
    
    //MARK: Initializer
    
    override func didMoveToView(view: SKView) {
        stateMachine.enterState(GameSceneInitialState.self)
    }
    
    //MARK: Functions
    
    func addEntity(entity: GKEntity,toLayer layer:SKNode) {
        //Add Entity to set
        entities.insert(entity)
        
        //Add Sprites to Scene
        if let spriteNode = entity.componentForClass(SpriteComponent.self)?.node {
            layer.addChild(spriteNode)
        }
        
        //Add Components to System
        for componentSystem in self.componentSystems {
            componentSystem.addComponentWithEntity(entity)
        }
        if entity is EnemyEntity || entity is ProjectileEntity  {
            enemySystem.addComponentWithEntity(entity)
        }
        
        if entity is Mage1Entity || entity is Mage2Entity || entity is BossEntity {
            mageSystem.addComponentWithEntity(entity)
        }

        scrollerSystem.addComponentWithEntity(entity)
        
        
    }
    
    //MARK: Life Cycle
    
    override func update(currentTime: CFTimeInterval) {
        if displayFinale {
            stateMachine.enterState(GameSceneWinState.self)
        }
        if !pauseLoop {
            //Calculate delta time
            var deltaTime = currentTime - lastUpdateTimeInterval
            deltaTime = deltaTime > maximumUpdateDeltaTime ?
                maximumUpdateDeltaTime : deltaTime
            lastUpdateTimeInterval = currentTime
            
            //Update State machines
            stateMachine.updateWithDeltaTime(deltaTime)
            
            var playerEntity: PlayerEntity?
            
            //Update Entities
            for entity in entities {
                if entity is PlayerEntity{
                    playerEntity = entity as? PlayerEntity
                }
                entity.updateWithDeltaTime(deltaTime)
            }
            
            //Update Components
            for componentSystem in componentSystems {
                componentSystem.updateWithDeltaTime(deltaTime)
            }
            
            control.movement.x = movementStick.movement.x
            control.jumpPressed = jumpButton.jumpPressed
            control.firePressed = fireButton.firePressed
            scrollerSystem.updateWithDeltaTime(deltaTime, controlInput: control)
            
            jumpButton.jumpPressed = false
            
            enemySystem.updateWithDeltaTime(deltaTime, controlInput: enemyControl)
            mageSystem.updateWithDeltaTime(deltaTime, controlInput: mageControl)
            
            if control.firePressed {
                let atlas = SKTextureAtlas(named: "Projectile")
                let spriteNode = playerEntity?.spriteComponent.node
                let orientation: CGFloat = (spriteNode?.xScale)!
                let positionX = orientation >= 0 ? spriteNode!.position.x + 40 : spriteNode!.position.x - 40
                let projectile = ProjectileEntity(position: CGPoint(x: positionX, y: spriteNode!.position.y + 15), size: CGSize(width: 15, height: 8), orientation: orientation, texture: atlas.textureNamed("Cat_Bullet"), scene: self)
                projectile.spriteComponent.node.zPosition = GameSettings.GameParams.zValues.zWorldFront
                self.addEntity(projectile, toLayer: self.worldLayer)
                
                fireButton.firePressed = false
            }
        }
    }
    
    override func didFinishUpdate() {
        //Update UI
        
    }
    
    //MARK: Responders
    
    override func screenInteractionStarted(location: CGPoint) {
        
        if let node = nodeAtPoint(location) as? SKSpriteNode {
            let buttonAtlas = SKTextureAtlas(named: "Button")
//            let pauseButton = SKSpriteNode(texture: buttonAtlas.textureNamed("Pause"))
            if node.name == "PauseButton" {
                if pauseLoop {
                    node.texture = buttonAtlas.textureNamed("Pause")
                    stateMachine.enterState(GameSceneActiveState.self)
                } else {
                    node.texture = buttonAtlas.textureNamed("triangleR")
                    stateMachine.enterState(GameScenePausedState.self)
                }
                return
            }
        }
        
        //        control.jumpPressed = jumpButton.jump
        
    }
    
    override func screenInteractionMoved(location: CGPoint) {
        
        //        control.jumpPressed = jumpButton.jump
        
    }
    
    override func screenInteractionEnded(location: CGPoint) {
        
        //        control.jumpPressed = jumpButton.jump
        
    }
    
    override func buttonEvent(event:String,velocity:Float,pushedOn:Bool) {
        
    }
    
    override func stickEvent(event:String,point:CGPoint) {
        
    }
    
    
    //Physics Delegate
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        if let bodyA = contact.bodyA.node as? EntityNode,
            let bodyAent = bodyA.entity as? SGEntity,
            let bodyB = contact.bodyB.node as? EntityNode,
            let bodyBent = bodyB.entity as? SGEntity
        {
            contactBegan(bodyAent, nodeB: bodyBent)
            contactBegan(bodyBent, nodeB: bodyAent)
        }
        
    }
    
    func contactBegan(nodeA:SGEntity, nodeB:SGEntity) {
        nodeA.contactWith(nodeB)
    }
    
    //Camera Settings
    
    func setCameraConstraints() {
        
        guard let camera = camera else { return }
        
        if let player = worldLayer.childNodeWithName("playerNode") as? EntityNode {
            
            let zeroRange = SKRange(constantValue: 0.0)
            let playerNode = player
            let playerLocationConstraint = SKConstraint.distance(zeroRange, toNode: playerNode)
            
            let scaledSize = CGSize(width: SKMViewSize!.width * camera.xScale, height: SKMViewSize!.height * camera.yScale)
            
            let boardContentRect = worldFrame
            
            let xInset = min((scaledSize.width / 2), boardContentRect.width / 2)
            let yInset = min((scaledSize.height / 2), boardContentRect.height / 2)
            
            let insetContentRect = boardContentRect.insetBy(dx: xInset, dy: yInset)
            
            let xRange = SKRange(lowerLimit: insetContentRect.minX + 110, upperLimit: insetContentRect.maxX)
            let yRange = SKRange(lowerLimit: insetContentRect.minY + 50, upperLimit: insetContentRect.maxY)
            
            let levelEdgeConstraint = SKConstraint.positionX(xRange, y: yRange)
            levelEdgeConstraint.referenceNode = worldLayer
            
            camera.constraints = [playerLocationConstraint, levelEdgeConstraint]
        }
    }
    
}
