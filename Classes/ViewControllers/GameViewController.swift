//
//  BaseViewController.swift
//  KeepRhythm
//
//  Created by Sroik on 8/4/15.
//  Copyright © 2015 Sroik. All rights reserved.
//

import SpriteKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.isMultipleTouchEnabled = false
        self.view.isExclusiveTouch = true
        
        let skView = SKView(frame: self.view.frame)
        
        self.view.addSubview(skView)
        
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.backgroundColor = UIColor.black
        skView.ignoresSiblingOrder = true
        
        let gameScene = GameScene(size: self.view.frame.size)
        
        skView.presentScene(gameScene)
        
        GameCenterManager.sharedManager.rootController = self
        GameCenterManager.sharedManager.authenticateLocalUserInBackground()
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    
}
