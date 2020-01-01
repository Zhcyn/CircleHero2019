//
//  GameScene.swift
//  Circle Hero
//
//  Created by Sroik on 8/5/15.
//  Copyright © 2015 Sroik. All rights reserved.
//

import SpriteKit

private let kIsLastUsedDarkThemeKey = "is_last_used_dark"

private let kButtonsIndent: CGFloat = 1.0
private let kButtonsSize: CGFloat = screenHeight*0.1

private let kBestScoreFontSize: CGFloat = screenHeight*0.05
private let kplayButtonSize: CGSize = CGSize(width: screenHeight*0.25, height: screenHeight*0.08)
private let kCircleToItemsIndent: CGFloat = screenHeight*0.11

private let kCircleDiameter: CGFloat = screenHeight*0.45

class GameScene: SKScene, CircleNodeDelegate {
    
    var achivmentButton: Button!
    var soundButton: SoundButton!
    var themeButton: ThemeButton!
    
    var circleNode: CircleNode!
    
    var theme: Theme = Theme.darkTheme()
    
    var playButton: Button!
    var bestScoreLabel: SKLabelNode!
    
    var isWatingForStart: Bool = true
    var isDarkTheme: Bool = true
    
    override init(size: CGSize) {
        super.init(size: size)
        
        self.isDarkTheme = UserDefaults.standard.bool(forKey: kIsLastUsedDarkThemeKey)
        
        self.setupContentsAndAnimations()
        self.switchTheme()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
//MARK:- setup methods
    
    func setupContentsAndAnimations() {
        self.isUserInteractionEnabled = true
        self.backgroundColor = self.theme.backgroundColor
        
        self.setupCircleNode()
        self.setupAchivmentButton()
        self.setupSoundButton()
        self.setupBestScoreLabel()
        self.setupplayButton()
        self.setupThemeButton()
        
        self.subscribeForNotification()
    }
    
    func setupAchivmentButton() {
        self.achivmentButton = Button(imageNamed: "achivment.png", color: self.theme.fragmentsColor)

        self.achivmentButton.setTarget(self, action: #selector(GameScene.achivmentPressed))
        
        self.achivmentButton.size = CGSize(width: kButtonsSize, height: kButtonsSize)
        self.achivmentButton.position = CGPoint(x: kButtonsIndent + kButtonsSize/2.0,
            y: self.frame.height - kButtonsIndent - kButtonsSize/2.0)
        
        self.addChild(self.achivmentButton)
        
        if (!GameCenterManager.sharedManager.gameCenterEnabled) {
            self.achivmentButton.alpha = 0.0
        }
    }
    
    func setupSoundButton() {
        self.soundButton = SoundButton(size: CGSize(width: kButtonsSize, height: kButtonsSize), color: self.theme.fragmentsColor)
        self.soundButton.setEnabled(SoundManager.isSoundEnabled())
        
        self.soundButton.setTarget(self, action: #selector(GameScene.soundPressed))
        
        self.soundButton.position = CGPoint(x: self.frame.width - kButtonsIndent - kButtonsSize/2.0, y: self.frame.height - kButtonsIndent - kButtonsSize/2.0)
        
        self.addChild(self.soundButton)
    }

    func setupThemeButton() {
        self.themeButton = ThemeButton(size: CGSize(width: kButtonsSize, height: kButtonsSize), color: self.theme.fragmentsColor)
        
        self.themeButton.setDark(self.isDarkTheme)
        self.themeButton.setTarget(self, action: #selector(GameScene.themePressed))
        self.themeButton.position = CGPoint(x: kButtonsIndent + kButtonsSize/2.0, y: kButtonsIndent + kButtonsSize/2.0)
        
        self.addChild(self.themeButton)
    }
    
    func setupCircleNode() {
        self.circleNode = CircleNode(diameter:kCircleDiameter, theme: self.theme)
        self.circleNode.delegate = self
        self.circleNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        self.addChild(self.circleNode)
    }
    
    func setupBestScoreLabel() {
        self.bestScoreLabel = SKLabelNode(text: "BEST: \(GameManager.bestScore())")
        self.bestScoreLabel.fontName = "AvenirNext-Regular"
        self.bestScoreLabel.fontSize = kBestScoreFontSize
        self.bestScoreLabel.fontColor = self.theme.bestScoreColor
        self.bestScoreLabel.position = CGPoint(x: self.frame.midX, y: self.circleNode.frame.maxY + kCircleToItemsIndent)
        
        self.addChild(self.bestScoreLabel)
    }
    
    func setupplayButton() {
        self.playButton = Button(imageNamed: "play.png", color: self.theme.fragmentsColor)
        self.playButton.setTarget(self, action: #selector(GameScene.playPressed))
        self.playButton.size = kplayButtonSize
        self.playButton.position = CGPoint(x: self.frame.midX, y: self.circleNode.frame.minY - kCircleToItemsIndent)
        
        self.addChild(self.playButton)
    }
    
//MARK: notification handling
    
    func subscribeForNotification() {
        NotificationCenter.default.addObserver(self,
            selector: #selector(GameScene.gameCenterManagerDidAuthenticate),
            name: NSNotification.Name(rawValue: GameCenterManagerDidAuthenticateNotification),
            object: nil)
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(GameScene.bestScoreDidUpdateNotification),
            name: NSNotification.Name(rawValue: BestScoreIncreasedNotification),
            object: nil)
    }
    
    @objc func bestScoreDidUpdateNotification(){
        self.bestScoreLabel.text = "BEST: \(GameManager.bestScore())"
    }
    
    @objc func gameCenterManagerDidAuthenticate() {
        self.achivmentButton.alpha = 1.0
    }
     
//MARK:- internals method
    
    func shakeCircle() {
        let act1 = SKAction.moveBy(x: 6.0, y: 0.0, duration: 0.15)
        let act2 = SKAction.moveBy(x: -12.0, y: 0.0, duration: 0.15)
        let act3 = SKAction.moveBy(x: 9.0, y: 0.0, duration: 0.08)
        let act4 = SKAction.moveBy(x: -6.0, y: 0.0, duration: 0.08)
        let act5 = SKAction.moveBy(x: 3.0, y: 0.0,duration: 0.05)
        
        let sequence = SKAction.sequence([act1,act2,act3,act4,act5])
        
        self.circleNode.run(sequence)
    }
    
    func hideButtons() {
        self.playButton.run(SKAction.fadeOut(withDuration: kDefaultAnimationDuration))
        self.playButton.isUserInteractionEnabled = false
        
        self.themeButton.run(SKAction.fadeOut(withDuration: kDefaultAnimationDuration))
        self.themeButton.isUserInteractionEnabled = false

    }
    
    func showButtons() {
        self.playButton.run(SKAction.fadeIn(withDuration: kDefaultAnimationDuration))
        self.playButton.isUserInteractionEnabled = true
        
        self.themeButton.run(SKAction.fadeIn(withDuration: kDefaultAnimationDuration))
        self.themeButton.isUserInteractionEnabled = true
    }
    
    func switchTheme() {
        self.isWatingForStart = true
        
        self.theme = self.isDarkTheme ? Theme.darkTheme() : Theme.lightTheme()
        
        self.removeAllChildren()
        self.setupContentsAndAnimations()
    }
    
//MARK:- buttons handling
    
    @objc func achivmentPressed() {
        GameCenterManager.sharedManager.showLeaderboard()
        
        SoundManager.playClick()
    }
    
    @objc func soundPressed() {
        let isSoundEnabled = !self.soundButton.isEnabled
        self.soundButton.setEnabled(isSoundEnabled)
        
        SoundManager.setSoundEnabled(isSoundEnabled)
        SoundManager.playClick()
    }
    
    @objc func themePressed() {
        let isDark = self.themeButton.isDark
        self.themeButton?.setDark(!isDark)

        self.isDarkTheme = !isDark
        
        UserDefaults.standard.set(self.isDarkTheme, forKey: kIsLastUsedDarkThemeKey)
        
        self.switchTheme()
        
        SoundManager.playClick()
    }
    
    @objc func playPressed() {
        self.circleNode.startGame()
        self.hideButtons()
        self.isWatingForStart = false
        
        SoundManager.playClick()
    }

//MARK:- circle node delegate methods
    
    func circleNodeDidLose(_ circleNode: CircleNode) {
        self.isWatingForStart = true
        self.showButtons()
        self.shakeCircle()
        
        SoundManager.playWrong()
        SoundManager.vibrate()
    }
    
//MARK:- touches handling
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !self.isWatingForStart {
            self.circleNode.checkIndicatorPosition()
        }
    }
    
}
