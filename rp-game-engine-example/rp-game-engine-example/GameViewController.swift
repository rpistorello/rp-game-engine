//
//  GameViewController.swift
//  rp-game-engine-example
//
//  Created by Ricardo on 19/02/16.
//  Copyright (c) 2016 Ricardo Pistorello. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    static var instance: GameViewController!
    static var mainView: SKView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        GameViewController.instance = self
        GameViewController.mainView = self.view as! SKView
        
        // Configure the view.
        let skView = GameViewController.mainView
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        
        let scene = GameScene(size: UIScreen.mainScreen().bounds.size)
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
    
            skView.presentScene(scene)
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
