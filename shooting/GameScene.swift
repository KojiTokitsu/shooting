//
//  GameScene.swift
//  shooting
//
//  Created by 時津幸司 on 2016/05/04.
//  Copyright (c) 2016年 時津幸司. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var ship = SKSpriteNode(imageNamed:"Spaceship")
    let shipCategory:UInt32 = 0x1 << 0
    let ballCategory:UInt32 = 0x1 << 1

    // Config
    var shipScale:CGFloat = 0.12 // bigger to harder default:0.12
    let shotRate:Int = 50 // smaller to harder default:50
    let shots = 24 // bigger to harder default:24
    let ballScale:CGFloat = 0.5 // bigger to harder default:0.5
    let ballSpeed:CGFloat = 0.1 // bigger to harder default:0.1

    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.backgroundColor = SKColor(colorLiteralRed: 0.15, green: 0.15, blue: 0.3, alpha: 1.0)
        self.physicsWorld.contactDelegate = self
        self.size = view.bounds.size
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsWorld.gravity = CGVectorMake(0,-3)
        setupShip()
        self.addChild(ship)
    }
    
    func setupShip(){
        ship.xScale = shipScale
        ship.yScale = shipScale
        ship.position = CGPoint(x:self.size.width / 2, y:self.size.height / 4)
        ship.physicsBody = SKPhysicsBody(circleOfRadius: ship.size.width / 2 / 12)
        ship.physicsBody!.categoryBitMask = shipCategory;
        ship.physicsBody!.contactTestBitMask = ballCategory;
        ship.physicsBody!.affectedByGravity = false;
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        let location = touches.first?.locationInNode(self)
        let x = self.size.width - (location?.x)!
        let y = self.size.height - (location?.y)!
        shot(CGPointMake(x, y))
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
        print("\(Int(ship.position.x)):\(Int(ship.position.y)):")
        // x:300-726
        // y:0 ^ 766
        
        switch random() % shotRate {
        case 0:
            let shotPoint:CGPoint = CGPoint(
                x:CGFloat(random()) % CGFloat(self.size.width),
                y:CGFloat(random()) % (CGFloat(self.size.height)/2) + (CGFloat(self.size.height)/2)
            )
            shot(shotPoint)
        default:
            break
        }
    }

    func shot(point: CGPoint) {
        for i in 0...shots {
            let ball = SKSpriteNode(imageNamed: "ball");
            ball.position = point
            ball.xScale = ballScale
            ball.yScale = ballScale
            ball.speed = ballSpeed
            ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
            ball.physicsBody!.contactTestBitMask = shipCategory
            ball.physicsBody!.categoryBitMask    = ballCategory
            ball.physicsBody!.collisionBitMask   = shipCategory
            let r  = self.size.height
            let x  = r * CGFloat(cos(Double(i) * (2 * M_PI ) / Double(shots)))
            let y  = r * CGFloat(sin(Double(i) * (2 * M_PI ) / Double(shots)))
            let move = SKAction.moveTo(CGPointMake(point.x+x, point.y+y),duration:1)
            let remove = SKAction.removeFromParent()
            let action = SKAction.sequence([move, remove])
            SKAction.repeatActionForever(action)
            ball.runAction(action)
            self.addChild(ball)
        }
    }

    func didBeginContact(contact: SKPhysicsContact)
    {
        contact.bodyA.node?.removeFromParent()
        contact.bodyB.node?.removeFromParent()
    }
}
