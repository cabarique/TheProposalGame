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

class TileLayer: SKNode, tileMapDelegate {
    var randomSceneryArt: [String] = []
    var textureAtlasName  = "Tiles"
    
    var levelGenerator = tileMapBuilder()
    var randomScenery: GKRandomDistribution!
    var atlasTiles: SKTextureAtlas!
    
    init(levelIndex:Int, typeIndex:setType, textureName: String) {
        super.init()
        
        randomScenery = GKRandomDistribution(forDieWithSideCount: randomSceneryArt.count)
        atlasTiles = SKTextureAtlas(named: textureName)
        levelGenerator.delegate = self
        
        levelGenerator.loadLevel(levelIndex, fromSet: typeIndex)
        levelGenerator.presentLayerViaDelegate(levelIndex)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: tileMapDelegate
    
    internal func createNodeOf(type type:tileType, location:CGPoint, level: Int) {
        
    }
}
