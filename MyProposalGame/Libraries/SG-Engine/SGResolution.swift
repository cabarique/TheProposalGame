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

///GLOBALS

var SKMViewSize:CGSize?    // The size of the visible area of the screen on current device (screen)
var SKMSceneSize:CGSize?   // The size of the scene itself (canvas)
var SKMUIRect:CGRect?      // The visible screen (screen) in relation to the scene (canvas)
var SKMScale:CGFloat?      // Assists with scaling assets up or down based on screen height

class SGResolution:NSObject {
  
  override init() {
    super.init()
  }
  
  /**
  Sets the global variables, usually run on app launch.
  */
  
  convenience init(screenSize:CGSize, canvasSize:CGSize) {
    self.init()
    
    if (screenSize.height < screenSize.width) {
      SKMViewSize = screenSize
    } else {
      SKMViewSize = CGSize(width:screenSize.height, height:screenSize.width)
    }
    
    SKMSceneSize = canvasSize
    
    SKMScale = (SKMViewSize!.height / SKMSceneSize!.height)
    
    let scale:CGFloat = min( SKMSceneSize!.width/SKMViewSize!.width, SKMSceneSize!.height/SKMViewSize!.height )
    SKMUIRect = CGRect(x: ((((SKMViewSize!.width * scale) - SKMSceneSize!.width) * 0.5) * -1.0), y: ((((SKMViewSize!.height * scale) - SKMSceneSize!.height) * 0.5) * -1.0), width: SKMViewSize!.width * scale, height: SKMViewSize!.height * scale)
    
    if GameSettings.Debugging.ALL_TellMeStatus {
      print("[SGResolution] Canvas: w \(SKMSceneSize!.width) h \(SKMSceneSize!.height)", terminator: "")
      print("[SGResolution] Screen: w \(SKMViewSize!.width) h \(SKMViewSize!.height)", terminator: "")
      print("[SGResolution] UI Scale: \(SKMScale!)", terminator: "")
    }
    
  }
  
  
}