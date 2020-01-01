//
//  GameCenterManager.swift
//  CircleHero
//
//  Created by Sroik on 9/21/15.
//  Copyright © 2015 Sroik. All rights reserved.
//

import GameKit

let GameCenterManagerDidAuthenticateNotification = "gameCenterManagerDidAuthenticate"

class GameCenterManager: NSObject, GKGameCenterControllerDelegate {
    
    static let sharedManager: GameCenterManager = GameCenterManager()
    
    var rootController: UIViewController?
    var gameCenterEnabled: Bool = false
    var gameCenterLeaderboardID: String?
    
    func authenticateLocalUser() {
        let localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = { (controller: UIViewController?, error: Error?) in
            if (controller != nil) {
                self.rootController?.present(controller!, animated: true, completion: nil)
            } else {
                if (localPlayer.isAuthenticated == true) {
                    self.gameCenterEnabled = true
                    
                    localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (identifier: String?, error: Error?) in
                        if (identifier != nil) {
                            self.gameCenterLeaderboardID = identifier
                            NotificationCenter.default.post(name: Notification.Name(rawValue: GameCenterManagerDidAuthenticateNotification), object: nil)
                        } else {
                            print("leader board id load error : \(error?.localizedDescription)")
                        }
                    })
                } else {
                    self.gameCenterEnabled = false
                }
            }
        }
    }
    
    func authenticateLocalUserInBackground() {
        DispatchQueue.global().async(execute: {
            self.authenticateLocalUser()
        })
    }
    
    func showLeaderboard() {
        if self.gameCenterEnabled && self.gameCenterLeaderboardID != nil {
            let gcController = GKGameCenterViewController()
        
            gcController.gameCenterDelegate = self
            gcController.viewState = .leaderboards
            gcController.leaderboardIdentifier = self.gameCenterLeaderboardID
        
            self.rootController?.present(gcController, animated: true, completion: nil)
        }
    }
    
    func reportScore(_ score: Int) {
        if self.gameCenterEnabled && self.gameCenterLeaderboardID != nil {
            let gkScore = GKScore(leaderboardIdentifier: self.gameCenterLeaderboardID!)
            gkScore.value = Int64(score)
        
            GKScore.report([gkScore], withCompletionHandler: nil)
        }
    }
    
//MARK: game center delegate methods
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}
