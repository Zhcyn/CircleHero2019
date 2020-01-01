//
//  GameManager.swift
//  CircleHero
//
//  Created by Sroik on 9/25/15.
//  Copyright © 2015 Sroik. All rights reserved.
//

import UIKit

let BestScoreIncreasedNotification = "BestScoreIncreased"
private let kBestScoreKey = "best_score"

class GameManager {

    static let sharedManager = GameManager()
    
    var currentScore: Int = 0
    var best: Int = 0
    
    init() {
        self.best = UserDefaults.standard.integer(forKey: kBestScoreKey)
    }
    
    class func bestScore() -> Int {
        return sharedManager.best
    }
    
    class func setBestScore(_ score: Int) {
        GameCenterManager.sharedManager.reportScore(score)
        sharedManager.best = score
        UserDefaults.standard.set(score, forKey: kBestScoreKey)
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: BestScoreIncreasedNotification), object: nil)
    }
    
    class func increaseCurrentScore() {
        sharedManager.currentScore += 1
        if sharedManager.currentScore > sharedManager.best {
            self.setBestScore(sharedManager.currentScore)
        }
    }
    
    class func score() -> Int {
        return sharedManager.currentScore
    }
    
    class func restart() {
        sharedManager.currentScore = 0
    }
}
