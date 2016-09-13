//
//  GameViewController.swift
//  MyProposalGame
//
//  Created by Luis Cabarique on 9/12/16.
//  Copyright (c) 2016 Luis Cabarique. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = GameScene(size: CGSize(width: 1024, height: 768))
        let skView = self.view as! SKView
        
        skView.multipleTouchEnabled = true
        
        if GameSettings.Debugging.ALL_TellMeStatus {
            skView.showsFPS = GameSettings.Debugging.ALL_ShowFrameRate
            skView.showsNodeCount = GameSettings.Debugging.ALL_ShowNodeCount
            skView.showsDrawCount = GameSettings.Debugging.IOS_ShowDrawCount
            skView.showsQuadCount = GameSettings.Debugging.IOS_ShowQuadCount
            skView.showsPhysics = GameSettings.Debugging.IOS_ShowPhysics
            skView.showsFields = GameSettings.Debugging.IOS_ShowFields
        }
        
        skView.ignoresSiblingOrder = true
        
        scene.scaleMode = .AspectFill
        
        _ = SGResolution(screenSize: view.bounds.size, canvasSize: scene.size)
        
        skView.presentScene(scene)
        
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Landscape
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
