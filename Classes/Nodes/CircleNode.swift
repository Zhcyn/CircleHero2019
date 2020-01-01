//
//  CircleNode.swift
//  CircleHero
//
//  Created by Sroik on 10/8/14.
//  Copyright © 2014 Sroik. All rights reserved.
//

import SpriteKit

private let kCircleLineWidth: CGFloat = screenHeight*0.028

private let kIndicatorLength: CGFloat = 6.0
private let kMaxIndicatorIndentForLose: CGFloat = CGFloat(0.2*M_PI_4)

private let kTargetNodeMinLength: CGFloat = 15.0
private let kStartTargetNodeMaxLength: CGFloat = 40.0
private let kStabilityTargetMaxLength: CGFloat = 30.0

private let kStabilityIndicatorMinDurationPerRadian: CGFloat = 0.3
private let kDurationPerRadianDispersion: CGFloat = 0.25
private let kStartMinDurationPerRadian: CGFloat = 0.45

private let kScoreNeededForStability: Int = 20

private let kMinTargetRadiansPerReset: CGFloat = CGFloat(M_PI_2)
private let kScoreFontSize: CGFloat = screenHeight*0.16

protocol CircleNodeDelegate: class {
    func circleNodeDidLose(_ circleNode: CircleNode)
}

class CircleNode: SKSpriteNode {
    
    weak var delegate: CircleNodeDelegate?
    
    var theme: Theme!
    var circleNode: SKShapeNode!
    var scoreNode: SKLabelNode?
    
    var targetNode: SKShapeNode?
    var indicatorNode: SKShapeNode!

    var currentIndicatorPositionRadians: CGFloat = 0.0
    
    var currentTargetPositionRadians: CGFloat = 0.0
    var currentTargetLengthRadians: CGFloat = 0.0
    var isClockWiseCurrentIndicator: Bool = true;
    
    init(diameter: CGFloat, theme: Theme) {
        super.init(texture: nil, color: SKColor.clear, size: CGSize(width: diameter, height: diameter))
        self.theme = theme
        self.setupContentsAndAnimations()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK:- setup methods
    
    func setupContentsAndAnimations() {
        self.isUserInteractionEnabled = false
        self.anchorPoint = kCenterAnchor
        
        self.setupCircleNode()
        self.setupIndicatorNode()
        self.setupScoreNode()
    }
    
    func setupCircleNode() {
        self.circleNode = SKShapeNode(circleOfRadius: self.frame.width/2.0)

        self.circleNode.fillColor = SKColor.clear
        self.circleNode.strokeColor = self.theme.fragmentsColor
        self.circleNode.lineWidth = kCircleLineWidth
     
        self.circleNode.position = CGPoint(x: 0.0, y: 0.0)
        
        self.addChild(self.circleNode)
    }
    
    func setupIndicatorNode() {
        let indicatorPath = UIBezierPath.arcPathWithRadius(self.frame.width/2.0,
            angle: arcAngleForLength(kIndicatorLength,arcRadius: self.frame.width/2.0), width: kCircleLineWidth - 1.0)
        
        self.indicatorNode = SKShapeNode(path: indicatorPath.cgPath)
        
        self.indicatorNode.strokeColor = self.theme.indicatorColor
        self.indicatorNode.fillColor = self.theme.indicatorColor
        self.indicatorNode.lineWidth = 1.0
        
        self.indicatorNode.zPosition = 100.0
        
        self.addChild(self.indicatorNode)
    }
    
    func setupScoreNode() {
        self.scoreNode = SKLabelNode(text: "0")
        self.scoreNode?.fontName = "HelveticaNeue-Light"
        self.scoreNode?.fontSize = kScoreFontSize
        self.scoreNode?.fontColor = self.theme.fragmentsColor
        self.scoreNode?.position = CGPoint(x: self.frame.midX, y: self.frame.midY - self.scoreNode!.frame.height/2.0)
        
        self.addChild(self.scoreNode!)
    }
    
//MARK:- public methods
    
    func startGame() {
        GameManager.restart()
        self.scoreNode?.text = "\(GameManager.score())"
        
        self.repositionTarget()
        self.startIndicatorRotation()
    }
    
//MARK:- internals methods
    
    func repositionTarget() {
        self.targetNode?.removeFromParent()
        
        let maxLength = kStartTargetNodeMaxLength - CGFloat(GameManager.score())/CGFloat(kScoreNeededForStability)*(kStartTargetNodeMaxLength - kStabilityTargetMaxLength)

        let targetLength = CGFloat.random(kTargetNodeMinLength, to: maxLength)
        self.currentTargetLengthRadians = degreeToRadians(arcAngleForLength(targetLength,arcRadius: self.frame.width/2.0))
        
        let targetPath = UIBezierPath.arcPathWithRadius(self.frame.width/2.0,
            angle: arcAngleForLength(targetLength, arcRadius: self.frame.width/2.0), width: kCircleLineWidth - 3.0)
        
        self.targetNode = SKShapeNode(path: targetPath.cgPath)
        
        self.targetNode?.strokeColor = self.theme.targetColor
        self.targetNode?.fillColor = self.theme.targetColor
        self.targetNode?.lineWidth = 3.0
        
        self.targetNode?.zPosition = 99.0
        
        var randomRadians = CGFloat.random()*2.0*CGFloat(M_PI_4)
        if fabs(randomRadians - self.currentTargetPositionRadians) < kMinTargetRadiansPerReset {
            randomRadians = self.currentTargetPositionRadians + kMinTargetRadiansPerReset
            randomRadians = (randomRadians <= 2.0*CGFloat(M_PI)) ? randomRadians : (randomRadians - 2.0*CGFloat(M_PI))
        }
        
        self.currentTargetPositionRadians = randomRadians;
        
        let rotateAction = SKAction.rotate(toAngle: randomRadians, duration: 0.0)
        self.targetNode?.run(rotateAction)
        
        self.addChild(self.targetNode!)
    }
    
    func startIndicatorRotation() {
        var possibleIndicatorIndent = -self.currentTargetLengthRadians - kMaxIndicatorIndentForLose
        if (!self.isClockWiseCurrentIndicator) {
            let indicatorLengthRadians = degreeToRadians(arcAngleForLength(kIndicatorLength, arcRadius: self.frame.width/2.0))
            possibleIndicatorIndent = indicatorLengthRadians + kMaxIndicatorIndentForLose
        }
        
        let endRadians = self.currentTargetPositionRadians + possibleIndicatorIndent

        var byAngle = endRadians - self.currentIndicatorPositionRadians
        
        if (self.isClockWiseCurrentIndicator && (self.currentIndicatorPositionRadians < endRadians)) {
            byAngle = byAngle - CGFloat(2.0*M_PI)
        } else if (!self.isClockWiseCurrentIndicator && (self.currentIndicatorPositionRadians > endRadians)) {
            byAngle = byAngle + CGFloat(2.0*M_PI)
        }
        
        let duration: TimeInterval = TimeInterval(self.indicatorSpeedPerRadian()*fabs(byAngle));
        let rotateAction = SKAction.rotate(byAngle: byAngle, duration: duration)
        self.indicatorNode.run(rotateAction, completion: {
            self.gameOver()
        })
        
        self.currentIndicatorPositionRadians = endRadians
    }
    
    func indicatorSpeedPerRadian() -> CGFloat {
        let stabilityDecrease = (CGFloat(GameManager.score())/CGFloat(kScoreNeededForStability))*(kStartMinDurationPerRadian-kStabilityIndicatorMinDurationPerRadian)
        
        let min = kStartMinDurationPerRadian - stabilityDecrease
        let max = kStartMinDurationPerRadian + kDurationPerRadianDispersion - stabilityDecrease
        
        let speed: CGFloat = CGFloat.random(min, to: max)
        return speed
    }
    
    func gameOver() {
        self.isClockWiseCurrentIndicator = !self.isClockWiseCurrentIndicator
        self.delegate?.circleNodeDidLose(self)
    }
    
    func onHitTarget() {
        SoundManager.playClick()
        
        GameManager.increaseCurrentScore()
        self.scoreNode?.text = "\(GameManager.score())"
        self.isClockWiseCurrentIndicator = !self.isClockWiseCurrentIndicator
     
        self.repositionTarget()
        self.startIndicatorRotation()
    }
    
//MARK:- touches handling
    
    func checkIndicatorPosition() {
        self.indicatorNode.removeAllActions()
        
        let indicatorLengthRadians = degreeToRadians(arcAngleForLength(kIndicatorLength, arcRadius: self.frame.width/2.0))
        let minPositionRadiansNeeded = self.currentTargetPositionRadians - self.currentTargetLengthRadians + indicatorLengthRadians/2.0
        let maxPositionRadiansNeeded = self.currentTargetPositionRadians + indicatorLengthRadians/2.0
        
        var indicatorPositionRadians = self.indicatorNode.zRotation.truncatingRemainder(dividingBy: CGFloat(2.0*M_PI))
        if indicatorPositionRadians < 0.0 {
            indicatorPositionRadians += CGFloat(2.0*M_PI)
        }
        
        self.currentIndicatorPositionRadians = indicatorPositionRadians
        
        var isHitTarget = (indicatorPositionRadians <= maxPositionRadiansNeeded) && (indicatorPositionRadians >= minPositionRadiansNeeded)

        if (maxPositionRadiansNeeded > 0 && minPositionRadiansNeeded < 0) {
            let reversedMinPosition = 2.0*CGFloat(M_PI) + minPositionRadiansNeeded
            isHitTarget = (indicatorPositionRadians >= reversedMinPosition) || (indicatorPositionRadians <= maxPositionRadiansNeeded)
        }
        
        if (isHitTarget) {
            self.onHitTarget()
        } else {
            self.gameOver()
        }
    }
}
