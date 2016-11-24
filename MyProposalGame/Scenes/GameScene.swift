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

class GameScene: SGScene {
  override func didMoveToView(view: SKView) {
    
    //This scene acts as the first point of contact to start background music and pass off to main menu
    
    //Start Background Music
//    SKTAudio.sharedInstance().playBackgroundMusic("background_music_intro.wav")
//    SKTAudio.sharedInstance().backgroundMusicPlayer?.volume = 0.4
    
    //Transition to Main Menu
    let nextScene = MainMenu(size: self.scene!.size)
    nextScene.scaleMode = self.scaleMode
    self.view?.presentScene(nextScene)
    
    
//    let nextScene = GamePlayMode(size: self.scene!.size)
//    nextScene.levelIndex = 1
//    nextScene.scaleMode = self.scaleMode
//    self.view?.presentScene(nextScene)
    
//    let nextScene = GameBuildMode(size: self.scene!.size)
//    nextScene.scaleMode = self.scaleMode
//    self.view?.presentScene(nextScene)
  }
  
}
