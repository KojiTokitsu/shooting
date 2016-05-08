//
//  GameScene.swift
//  shooting
//
//  Created by 時津幸司 on 2016/05/04.
//  Copyright (c) 2016年 時津幸司. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var ship = SKSpriteNode(imageNamed:"Spaceship")

    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.backgroundColor = SKColor(colorLiteralRed: 0.15, green: 0.15, blue: 0.3, alpha: 1.0)
        self.physicsWorld.gravity = CGVectorMake(0,0)
        ship.xScale = 0.1
        ship.yScale = 0.1
        ship.position = CGPoint(x:500, y:350)
        self.addChild(ship)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch moves */
        let touch = touches.first!
        let location = touch.locationInNode(self)
        let prevLocation = touch.previousLocationInNode(self)
        ship.position.x += location.x - prevLocation.x
        ship.position.y += location.y - prevLocation.y
    }

    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        print("\(ship.position.x):\(ship.position.y):")
        // x:300-726
        // y:0 ^ 766
        switch rand() % 50 {
        case 0:
            let x = (rand()%426)+300
            let y = rand()%766
            shot(CGPointMake(CGFloat(x), CGFloat(y)))
        default:
            break
        }
    }
    func randFloat(x: Int)->CGFloat {
        return (CGFloat(arc4random_uniform(UInt32(x)) + 1) + CGFloat(arc4random_uniform(UInt32(RAND_MAX))) / (CGFloat(UInt32(RAND_MAX)) * 1.0))
    }
    
    func shot(point: CGPoint) {
        let separate = 12
//        let shotPoint = CGPointMake(point.x + CGFloat(arc4random_uniform(10)) , point.y + CGFloat(arc4random_uniform(10)))
        for i in 0...separate {
            let ball = SKSpriteNode(imageNamed: "ball");
            ball.position = point
            ball.xScale = 0.5
            ball.yScale = 0.5
            ball.speed = 0.1
            let pr = ball.size.width/2
            ball.physicsBody = SKPhysicsBody(circleOfRadius: pr)
            ball.physicsBody!.contactTestBitMask = 0x1<<1
            ball.physicsBody!.categoryBitMask    = 0x1<<0
            ball.physicsBody!.collisionBitMask   = 0x1<<1
            let r  = self.size.height
            let x  = r * CGFloat(cos(Double(i) * (2 * M_PI ) / Double(separate)))
            let y  = r * CGFloat(sin(Double(i) * (2 * M_PI ) / Double(separate)))
            let move = SKAction.moveTo(CGPointMake(point.x+x, point.y+y),duration:1)
            let remove = SKAction.removeFromParent()
            let action = SKAction.sequence([move, remove])
            SKAction.repeatActionForever(action)
            ball.runAction(action)
            self.addChild(ball)
        }
    }
}
