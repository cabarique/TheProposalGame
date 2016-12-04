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

enum tileType: Int {
    case tileNotifier            = -1
    case tileAir                 = 0
    case tileGroundLeft          = 1
    case tileGround              = 2
    case tileGroundRight         = 3
    case tileWallLeft            = 4
    case tileGroundMiddle        = 5
    case tileWallRight           = 6
    case tileGroundCornerR       = 7
    case tileGroundCornerRU      = 8
    case tileCeiling             = 9
    case tileGroundCornerLU      = 10
    case tileGroundCornerL       = 11
    case tileCeilingLeft         = 12
    case tileCeilingRight        = 13
    case tilePlatformLeft        = 14
    case tilePlatform            = 15
    case tilePlatformRight       = 16
    case tileWaterSurface        = 17
    case tileWater               = 18
    case tileRandomScenery       = 19
    case tileSignPost            = 20
    case tileSignArrow           = 21
    case tileCrate               = 22
    case tileStartLevel          = 23
    case tileEndLevel            = 24
    case tileDiamond             = 25
    case tileCoin                = 26
    case tileZombie              = 27
    case tileZombie2             = 28
    case tileMage1               = 29
    case tileMage2               = 30
    case tileBoss                = 31
    case tilePrincess            = 32
    case tileEndDialog           = 33
}

protocol tileMapDelegate {
    func createNodeOf(type type:tileType, location:CGPoint, level: Int)
}

struct tileMapBuilder {
    
    var delegate: tileMapDelegate?
    
    var tileSize = CGSize(width: 32, height: 32)
    var tileLayer: [[Int]] = Array()
    var mapSize:CGPoint {
        get {
            return CGPoint(x: tileLayer[0].count, y: tileLayer.count)
        }
    }
    
    //MARK: Setters and getters for the tile map
    
    mutating func setTile(position position:CGPoint, toValue:Int) {
        tileLayer[Int(position.y)][Int(position.x)] = toValue
    }
    
    func getTile(position position:CGPoint) -> Int {
        return tileLayer[Int(position.y)][Int(position.x)]
    }
    
    //MARK: Level creation
    
    mutating func loadLevel(level:Int, fromSet set:setType) {
        switch set {
        case .setMain:
            tileLayer = tileMapLevels.MainSet[level]
            break
        case .setBuilder:
            tileLayer = tileMapLevels.BuilderSet[level]
            break
        }
    }
    
    //MARK: Presenting the layer
    
    func presentLayerViaDelegate(level: Int) {
        for (indexr, row) in tileLayer.enumerate() {
            for (indexc, cvalue) in row.enumerate() {
                if (delegate != nil) {
                    delegate!.createNodeOf(type: tileType(rawValue: cvalue)!,
                                           location: CGPoint(
                                            x: tileSize.width * CGFloat(indexc),
                                            y: tileSize.height * CGFloat(-indexr)), level: level)
                }
            }
        }
    }
    
    //MARK: Builder function
    
    func printLayer() {
        print("Tile Layer:")
        for row in tileLayer {
            print(row)
        }
    }
    
}









