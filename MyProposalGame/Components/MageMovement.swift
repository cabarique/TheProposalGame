//
//  MageMovement.swift
//  MyProposalGame
//
//  Created by Luis Cabarique on 10/24/16.
//  Copyright © 2016 Luis Cabarique. All rights reserved.
//


import SpriteKit
import GameplayKit

struct MageMoveControlScheme {
    
    //Input
    //    var didRise: Bool = false
    //var willDie: Bool               = false
}

class MageControlComponentSystem: GKComponentSystem {
    
    func updateWithDeltaTime(seconds: NSTimeInterval, controlInput: MageMoveControlScheme) {
        for component in components {
            if let comp = component as? MageMovementComponent {
                comp.updateWithDeltaTime(seconds, controlInput: controlInput)
            }
        }
    }
}

class MageMovementComponent: GKComponent {
    
    var isDying = false
    var deadTime: CGFloat = 0.0
    var isActive: Bool = false
    var riseTime: CGFloat = 0.0
    
    var lifePoints = 1
    
    var fireRate: CGFloat = 0.0
    var amunition = 2
    private var reloadTime: CGFloat = 2.0
    
    
    var spriteComponent: SpriteComponent {
        guard let spriteComponent = entity?.componentForClass(SpriteComponent.self) else { fatalError("SpriteComponent Missing") }
        return spriteComponent
    }
    
    var animationComponent: AnimationComponent {
        guard let animationComponent = entity?.componentForClass(AnimationComponent.self) else { fatalError("AnimationComponent Missing") }
        return animationComponent
    }
    
    init(entity: GKEntity) {
        super.init()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateWithDeltaTime(seconds: NSTimeInterval, controlInput: MageMoveControlScheme) {
        super.updateWithDeltaTime(seconds)
        
        if let enemyEnt = entity as? Mage1Entity {
            updateMage1WithDeltaTime(seconds, controlInput: controlInput, enemyEnt: enemyEnt)
        }else if let enemyEnt = entity as? Mage2Entity {
            updateMage2WithDeltaTime(seconds, controlInput: controlInput, enemyEnt: enemyEnt)
        }else {
            updateBossWithDeltaTime(seconds, controlInput: controlInput, enemyEnt: entity as! BossEntity)
        }
    }
    
    private func parabolicFire<T: ParabolicAttacking>(havingEnemy enemyEnt: T ){
        let atlas = SKTextureAtlas(named: "Projectile")
        let spriteNode = enemyEnt.spriteComponent.node
        let orientation: CGFloat = spriteNode.xScale
        let positionX = orientation >= 0 ? spriteNode.position.x + 30 : spriteNode.position.x - 30
        let gameScene = enemyEnt.gameScene
        var alfa: CGFloat = 35
        let deltaY = abs(abs(gameScene.camera!.position.y) - abs(spriteComponent.node.position.y))
        let delta = abs(abs(gameScene.camera!.position.x) - abs(spriteComponent.node.position.x))
        if deltaY < 10 {
            alfa = 40
        } else if deltaY > 100{
            alfa = 5
        }
        let xImpulse: CGFloat = ( delta * alfa ) / 83
        
        let projectile = ParabolicProjectileEntity(position: CGPoint(x: positionX, y: spriteNode.position.y + 40), size: CGSize(width: 20, height: 20), orientation: orientation, texture: atlas.textureNamed("Proyectil__000"), scene: enemyEnt.gameScene, impulseX: Double(xImpulse))
        projectile.spriteComponent.node.zPosition = GameSettings.GameParams.zValues.zWorldFront
        gameScene.addEntity(projectile, toLayer: gameScene.worldLayer)
    }
    
    private func groundFire<T: GroundAttacking>(havingEnemy enemyEnt: T) {
        let atlas = SKTextureAtlas(named: "Projectile")
        let spriteNode = enemyEnt.spriteComponent.node
        let orientation: CGFloat = spriteNode.xScale
        let positionX = orientation >= 0 ? spriteNode.position.x + 30 : spriteNode.position.x - 30
        let gameScene = enemyEnt.gameScene
        
        let projectile = GroundProjectileEntity(position: CGPoint(x: positionX, y: spriteNode.position.y + 20), size: CGSize(width: 30, height: 20), orientation: orientation, texture: atlas.textureNamed("Fantasma__001"), scene: enemyEnt.gameScene)
        projectile.spriteComponent.node.zPosition = GameSettings.GameParams.zValues.zWorldFront
        gameScene.addEntity(projectile, toLayer: gameScene.worldLayer)
    }
    
    private func summon<T: SummonAttacking>(havingEnemy enemyEnt: T) {
        let enemy1Atlas = SKTextureAtlas(named: "Zombie1")
        let spriteNode = enemyEnt.spriteComponent.node
        let gameScene = enemyEnt.gameScene
        
        let randomNumbers = [-20...10]
        let randomPosition = GKRandomDistribution(forDieWithSideCount: randomNumbers.count)
        let cameraPosition = gameScene.camera!.position
        let leftRange = cameraPosition.x - 90 + CGFloat(randomPosition.nextInt())
        
        let zombie = EnemyEntity(position: CGPoint(x: leftRange, y: spriteNode.position.y), size: CGSize(width: 48, height: 48.0), atlas: enemy1Atlas, scene: gameScene, name: "Zombie1")
        zombie.spriteComponent.node.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        zombie.spriteComponent.node.zPosition = GameSettings.GameParams.zValues.zPlayer - 1
        gameScene.addEntity(zombie, toLayer: gameScene.worldLayer)
        
    }
    
    func updateMage2WithDeltaTime(seconds: NSTimeInterval, controlInput: MageMoveControlScheme, enemyEnt: Mage2Entity){
        if enemyEnt.didRise {
            
            if !isActive {
                if riseTime == 0 {
                    riseTime = 0.4
                }else if riseTime > 0 {
                    riseTime = riseTime - CGFloat(seconds)
                }else{
                    isActive = true
                    enemyEnt.enablePhysicContacts()
                    //                    animationComponent.requestedAnimationState = .Idle
                }
                return
            }
            
            if isDying && deadTime > 0{
                deadTime = deadTime - CGFloat(seconds)
                return
            }
            
            if deadTime <= 0 && isDying {
                spriteComponent.node.removeFromParent()
                return
            }
            
            if reloadTime <= 0 {
                if fireRate <= 0 {
                    fireRate = 0.3
                }else if fireRate < 0.3 {
                    if fireRate < 0.15 {
                        animationComponent.requestedAnimationState = .Idle
                    }
                    fireRate = fireRate - CGFloat(seconds)
                }else if amunition > 0 {
                    animationComponent.requestedAnimationState = .Attack
                    amunition -= 1
                    parabolicFire(havingEnemy: enemyEnt)
                    fireRate = fireRate - CGFloat(seconds)
                }else{
                    amunition = 2
                    animationComponent.requestedAnimationState = .Idle
                    reloadTime = 4
                }
            }else{
                reloadTime = reloadTime - CGFloat(seconds)
            }
            
            
            let allContactedBodies = spriteComponent.node.physicsBody?.allContactedBodies()
            
            //Move sprite
            
            //when contacts with a tile, turns arround
            if allContactedBodies?.count > 0 {
                for body in allContactedBodies! {
                    
                    if lifePoints > 0 && body.node?.name == "projectileNode" && isActive {
                        lifePoints -= 1
                        body.node?.removeFromParent()
                    }
                    
                    if !isDying && body.node?.name == "projectileNode" && isActive && lifePoints == 0 {
                        body.node?.removeFromParent()
                        spriteComponent.node.physicsBody = nil
                        enemyEnt.gameScene.runAction(enemyEnt.gameScene.sndJump)
                        animationComponent.requestedAnimationState = .Dead
                        isDying = true
                        deadTime = 1
                        return
                    }
                }
            }
        }
    }
    
    func updateMage1WithDeltaTime(seconds: NSTimeInterval, controlInput: MageMoveControlScheme, enemyEnt: Mage1Entity) {
        if enemyEnt.didRise {
            
            if !isActive {
                if riseTime == 0 {
                    riseTime = 0.4
                }else if riseTime > 0 {
                    riseTime = riseTime - CGFloat(seconds)
                }else{
                    isActive = true
                    enemyEnt.enablePhysicContacts()
                }
                return
            }
            
            if isDying && deadTime > 0{
                deadTime = deadTime - CGFloat(seconds)
                return
            }
            
            if deadTime <= 0 && isDying {
                spriteComponent.node.removeFromParent()
                return
            }
            
            if reloadTime <= 0 {
                if fireRate <= 0 {
                    fireRate = 1
                }else if fireRate < 1 {
                    if fireRate < 0.5 {
                        animationComponent.requestedAnimationState = .Idle
                    }
                    fireRate = fireRate - CGFloat(seconds)
                }else if amunition > 0 {
                    animationComponent.requestedAnimationState = .Attack
                    amunition -= 1
                    groundFire(havingEnemy: enemyEnt)
                    fireRate = fireRate - CGFloat(seconds)
                }else{
                    amunition = 2
                    animationComponent.requestedAnimationState = .Idle
                    reloadTime = 3
                }
            }else{
                reloadTime = reloadTime - CGFloat(seconds)
            }
            
            
            let allContactedBodies = spriteComponent.node.physicsBody?.allContactedBodies()
            
            //Move sprite
            
            //when contacts with a tile, turns arround
            if allContactedBodies?.count > 0 {
                for body in allContactedBodies! {
                    
                    if lifePoints > 0 && body.node?.name == "projectileNode" && isActive {
                        lifePoints -= 1
                        body.node?.removeFromParent()
                    }
                    
                    if !isDying && body.node?.name == "projectileNode" && isActive && lifePoints == 0 {
                        body.node?.removeFromParent()
                        spriteComponent.node.physicsBody = nil
                        enemyEnt.gameScene.runAction(enemyEnt.gameScene.sndJump)
                        animationComponent.requestedAnimationState = .Dead
                        isDying = true
                        deadTime = 1
                        return
                    }
                }
            }
        }
    }
    
    
    private let bossAttackOptions = ["parabolic", "summon", "ground"]
    private var bossAttack = 0
    func updateBossWithDeltaTime(seconds: NSTimeInterval, controlInput: MageMoveControlScheme, enemyEnt: BossEntity) {
        if enemyEnt.didRise {
            
            if !isActive {
                if riseTime == 0 {
                    riseTime = 0.4
                }else if riseTime > 0 {
                    riseTime = riseTime - CGFloat(seconds)
                }else{
                    isActive = true
                    enemyEnt.enablePhysicContacts()
                }
                return
            }
            
            if isDying && deadTime > 0{
                deadTime = deadTime - CGFloat(seconds)
                return
            }
            
            if deadTime <= 0 && isDying {
                spriteComponent.node.removeFromParent()
                return
            }
            
            if reloadTime <= 0 {
                if fireRate <= 0 {
                    fireRate = 0.3
                }else if fireRate < 0.3 {
                    if fireRate < 0.15 {
                        animationComponent.requestedAnimationState = .Idle
                    }
                    fireRate = fireRate - CGFloat(seconds)
                }else if amunition > 0 {
                    animationComponent.requestedAnimationState = .Attack
                    amunition -= 1
                    if bossAttackOptions[bossAttack] == "parabolic" {
                        parabolicFire(havingEnemy: enemyEnt)
                    }else if bossAttackOptions[bossAttack] == "summon" {
                        groundFire(havingEnemy: enemyEnt)
                    }else{
                        summon(havingEnemy: enemyEnt)
                    }
                    fireRate = fireRate - CGFloat(seconds)
                }else{
                    amunition = 2
                    animationComponent.requestedAnimationState = .Idle
                    reloadTime = 3
                    bossAttack = (bossAttackOptions.count - 1 ) == bossAttack ?  0 : bossAttack + 1
                }
            }else{
                reloadTime = reloadTime - CGFloat(seconds)
            }
            
            
            let allContactedBodies = spriteComponent.node.physicsBody?.allContactedBodies()
            
            //Move sprite
            
            //when contacts with a tile, turns arround
            if allContactedBodies?.count > 0 {
                for body in allContactedBodies! {
                    
                    if lifePoints > 0 && body.node?.name == "projectileNode" && isActive {
                        lifePoints -= 1
                        body.node?.removeFromParent()
                    }
                    
                    if !isDying && body.node?.name == "projectileNode" && isActive && lifePoints == 0 {
                        body.node?.removeFromParent()
                        spriteComponent.node.physicsBody = nil
                        enemyEnt.gameScene.runAction(enemyEnt.gameScene.sndJump)
                        animationComponent.requestedAnimationState = .Dead
                        isDying = true
                        deadTime = 1
                        return
                    }
                }
            }
        }
    }
}
