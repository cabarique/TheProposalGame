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
import GameplayKit

enum toolSelection {
    case toolMove
    case toolAdd
    case toolRemove
}

class GameBuildMode: SGScene {
    
    //Layers
    var worldLayer:TileLayer!
    var overlayLayer = SKNode()
    
    //Tiles
    let tileImages = [
        "0","1","2","3","4","5","6","7","8","9",
        "10","11","12","13","14","15","16","17","18"
    ]
    
    let tileObjects = [
        "B3","Sign_1","Sign_2",
        "Crate","Mushroom_1","Mushroom_2", "diamondBlue", "Coin", "Zombie1", "Zombie2", "Mage1", "Mage2", "Boss", "Princess"
    ]
    
    //Tools
    var currentTool = toolSelection.toolMove
    var tilePanel: builderPanel?
    
    
    override func didMoveToView(view: SKView) {
        
        GameSettings.Builder.ALL_Black_Background = true
        
        //Setup camera
        let myCamera = SKCameraNode()
        camera = myCamera
        addChild(myCamera)
        
        //Setup Layers
        switch GameSettings.Builder.BUILDER_LEVEL {
        case 0:
            worldLayer = TileLayer1(levelIndex: GameSettings.Builder.BUILDER_LEVEL, typeIndex: .setBuilder)
            tilePanel = builderPanel(objectImages: tileObjects, objectTexture: "TileObjects", tileImages: tileImages, imagetexture: "Tiles")
        case 1:
            worldLayer = TileLayer2(levelIndex: GameSettings.Builder.BUILDER_LEVEL, typeIndex: .setBuilder)
            tilePanel = builderPanel(objectImages: tileObjects, objectTexture: "TileObjects", tileImages: tileImages, imagetexture: "Tiles2")
        case 2:
            worldLayer = TileLayer3(levelIndex: GameSettings.Builder.BUILDER_LEVEL, typeIndex: .setBuilder)
            tilePanel = builderPanel(objectImages: tileObjects, objectTexture: "TileObjects", tileImages: tileImages, imagetexture: "Tiles3")
        case 3:
            worldLayer = TileLayer4(levelIndex: GameSettings.Builder.BUILDER_LEVEL, typeIndex: .setBuilder)
            tilePanel = builderPanel(objectImages: tileObjects, objectTexture: "TileObjects", tileImages: tileImages, imagetexture: "Tiles4")
        default:
            worldLayer = TileLayer1(levelIndex: 0, typeIndex: .setBuilder)
            tilePanel = builderPanel(objectImages: tileObjects, objectTexture: "TileObjects", tileImages: tileImages, imagetexture: "Tiles")
        }
        
        addChild(worldLayer)
        myCamera.addChild(overlayLayer)
        updateTileMap()
        
        //UI Elements
        let modeButton = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        modeButton.posByScreen(-0.4, y: 0.4)
        modeButton.fontSize = 40
        modeButton.text = lt("Move")
        modeButton.fontColor = SKColor.whiteColor()
        modeButton.zPosition = 150
        modeButton.name = "modeSelect"
        overlayLayer.addChild(modeButton)
        
        let zoButton = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        zoButton.posByScreen(-0.4, y: -0.45)
        zoButton.fontSize = 30
        zoButton.text = lt("Zoom Out")
        zoButton.fontColor = SKColor.whiteColor()
        zoButton.zPosition = 150
        zoButton.name = "zoomOut"
        overlayLayer.addChild(zoButton)
        
        let ziButton = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        ziButton.posByScreen(-0.2, y: -0.45)
        ziButton.fontSize = 30
        ziButton.text = lt("Zoom In")
        ziButton.fontColor = SKColor.whiteColor()
        ziButton.zPosition = 150
        ziButton.name = "zoomIn"
        overlayLayer.addChild(ziButton)
        
        let upButton = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        upButton.posByScreen(0.35, y: 0.45)
        upButton.fontSize = 30
        upButton.text = lt("Up")
        upButton.fontColor = SKColor.whiteColor()
        upButton.zPosition = 150
        upButton.name = "Up"
        overlayLayer.addChild(upButton)
        
        let downButton = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        downButton.posByScreen(0.35, y: -0.45)
        downButton.fontSize = 30
        downButton.text = lt("Down")
        downButton.fontColor = SKColor.whiteColor()
        downButton.zPosition = 150
        downButton.name = "Down"
        overlayLayer.addChild(downButton)
        
        let printButton = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        printButton.posByScreen(0.0, y: -0.45)
        printButton.fontSize = 30
        printButton.text = lt("Print")
        printButton.fontColor = SKColor.whiteColor()
        printButton.zPosition = 150
        printButton.name = "Print"
        overlayLayer.addChild(printButton)
        
        let background = SKSpriteNode(imageNamed: "BG")
        background.position = CGPointZero
        background.xScale = 1.2
        background.yScale = 1.2
        background.alpha = 0.2
        background.zPosition = -1
        overlayLayer.addChild(background)
        
        tilePanel!.posByScreen(0.45, y: 0.45)
        tilePanel!.selectIndex(0)
        overlayLayer.addChild(tilePanel!)
        
    }
    
    //MARK: Responders
    
    override func screenInteractionStarted(location: CGPoint) {
        
        if let node = nodeAtPoint(location) as? SKLabelNode {
            if node.name == "modeSelect" {
                switch currentTool {
                case .toolMove:
                    node.text = lt("Add")
                    currentTool = .toolAdd
                    break
                case .toolAdd:
                    node.text = lt("Remove")
                    currentTool = .toolRemove
                    break
                case .toolRemove:
                    node.text = lt("Move")
                    currentTool = .toolMove
                    break
                }
                return
            }
            if node.name == "zoomOut" {
                if let camera = camera {
                    camera.xScale = camera.xScale + 0.2
                    camera.yScale = camera.yScale + 0.2
                }
                return
            }
            if node.name == "zoomIn" {
                if let camera = camera {
                    camera.xScale = camera.xScale - 0.2
                    camera.yScale = camera.yScale - 0.2
                }
                return
            }
            if node.name == "Up" {
                tilePanel!.position = CGPoint(x: tilePanel!.position.x, y: tilePanel!.position.y - 34)
                return
            }
            if node.name == "Down" {
                tilePanel!.position = CGPoint(x: tilePanel!.position.x, y: tilePanel!.position.y + 34)
                return
            }
            if node.name == "Print" {
                worldLayer.levelGenerator.printLayer()
                return
            }
        }
        if let node = nodeAtPoint(location) as? SKSpriteNode {
            if ((node.name?.hasPrefix("T_")) != nil) {
                tilePanel!.selectIndex((node.userData!["index"] as? Int)!)
                return
            }
        }
        
        
        switch currentTool {
        case .toolMove:
            if let camera = camera {
                camera.runAction(SKAction.moveTo(location, duration: 0.2))
                //print("x: \(floor(abs(location.x/32.0))) y: \(floor(abs(location.y/32.0)))")
            }
            break
        case .toolAdd:
            let locationInfo = locationToTileIndex(CGPoint(x: location.x + 16, y: location.y - 16))
            if locationInfo.valid == true {
                changeTile(tilePanel!.selectedIndex, location: locationInfo.tileIndex)
                updateTileMap()
            }
            break
        case .toolRemove:
            let locationInfo = locationToTileIndex(CGPoint(x: location.x + 16, y: location.y - 16))
            if locationInfo.valid == true {
                changeTile(0, location: locationInfo.tileIndex)
                updateTileMap()
            }
            break
        }
    }
    
    //MARK: functions
    
    func changeTile(tileCode:Int,location:CGPoint) {
        worldLayer.levelGenerator.setTile(position: location, toValue: tileCode)
    }
    
    func updateTileMap() {
        for child in worldLayer.children {
            child.removeFromParent()
        }
        worldLayer.levelGenerator.presentLayerViaDelegate(GameSettings.Builder.BUILDER_LEVEL)
        
        for child in worldLayer.children {
            if let name = child.name {
                switch name {
                case "placeholder_Diamond":
                    let label = SKLabelNode(text: "D")
                    label.zPosition = GameSettings.GameParams.zValues.zWorld + 1
                    label.position = child.position
                    worldLayer.addChild(label)
                    break
                case "placeholder_Coin":
                    let label = SKLabelNode(text: "C")
                    label.zPosition = GameSettings.GameParams.zValues.zWorld + 1
                    label.position = child.position
                    worldLayer.addChild(label)
                    break
                case "placeholder_StartPoint":
                    let label = SKLabelNode(text: "S")
                    label.zPosition = GameSettings.GameParams.zValues.zWorld + 1
                    label.position = child.position
                    worldLayer.addChild(label)
                    break
                case "placeholder_FinishPoint":
                    let label = SKLabelNode(text: "F")
                    label.zPosition = GameSettings.GameParams.zValues.zWorld + 1
                    label.position = child.position
                    worldLayer.addChild(label)
                    break
                case "placeholder_Zombie1":
                    let label = SKLabelNode(text: "Z1")
                    label.zPosition = GameSettings.GameParams.zValues.zWorld + 1
                    label.position = child.position
                    worldLayer.addChild(label)
                    break
                case "placeholder_Zombie2":
                    let label = SKLabelNode(text: "Z2")
                    label.zPosition = GameSettings.GameParams.zValues.zWorld + 1
                    label.position = child.position
                    worldLayer.addChild(label)
                    break
                case "placeholder_Mage1":
                    let label = SKLabelNode(text: "M1")
                    label.zPosition = GameSettings.GameParams.zValues.zWorld + 1
                    label.position = child.position
                    worldLayer.addChild(label)
                    break
                case "placeholder_Mage2":
                    let label = SKLabelNode(text: "M2")
                    label.zPosition = GameSettings.GameParams.zValues.zWorld + 1
                    label.position = child.position
                    worldLayer.addChild(label)
                    break
                    
                case "placeholder_Boss":
                    let label = SKLabelNode(text: "B")
                    label.zPosition = GameSettings.GameParams.zValues.zWorld + 1
                    label.position = child.position
                    worldLayer.addChild(label)
                    break
                    
                case "placeholder_Princess":
                    let label = SKLabelNode(text: "P")
                    label.zPosition = GameSettings.GameParams.zValues.zWorld + 1
                    label.position = child.position
                    worldLayer.addChild(label)
                    break
                
                default:
                    break
                }
            }
        }
    }
    
    func locationToTileIndex(location:CGPoint) -> (valid:Bool, tileIndex:CGPoint) {
        let newIndex = CGPoint(x: floor(abs(location.x/32.0)), y: floor(abs(location.y/32.0)))
        if (newIndex.x >= 0 && newIndex.x < worldLayer.levelGenerator.mapSize.x) &&
            (newIndex.y >= 0 && newIndex.y < worldLayer.levelGenerator.mapSize.y) {
            return (true, newIndex)
        } else {
            return (false, newIndex)
        }
    }
    
}

//Tile Panel

class builderPanel: SKNode {
    
    var atlasTiles: SKTextureAtlas!
    var atlasObjects: SKTextureAtlas!
    var selectedIndex = 0
    
    init(objectImages: [String], objectTexture: String, tileImages:[String], imagetexture: String) {
        super.init()
        atlasTiles = SKTextureAtlas(named: imagetexture)
        for (index, imageString) in tileImages.enumerate() {
            let node = SKSpriteNode(texture: atlasTiles.textureNamed(imageString))
            node.size = CGSize(width: 32, height: 32)
            node.position = CGPoint(x: 0, y: index * -34)
            node.alpha = 0.5
            node.zPosition = 150
            node.name = "T_\(index)"
            node.userData = ["index":index]
            addChild(node)
        }
        
        atlasObjects = SKTextureAtlas(named: objectTexture)
        for (i, imageString) in objectImages.enumerate() {
            let index = i + tileImages.count
            let node = SKSpriteNode(texture: atlasObjects.textureNamed(imageString))
            node.size = CGSize(width: 32, height: 32)
            node.position = CGPoint(x: 0, y: index * -34)
            node.alpha = 0.5
            node.zPosition = 150
            node.name = "T_\(index)"
            node.userData = ["index":index]
            addChild(node)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selectIndex(indexSelected:Int) {
        selectedIndex = indexSelected
        
        for child in children {
            if selectedIndex == (child.userData!["index"] as? Int)! {
                child.alpha = 1.0
                child.setScale(1.1)
            } else {
                child.alpha = 0.5
                child.setScale(1.0)
            }
        }
    }
    
}
