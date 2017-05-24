//
//  GameScene.swift
//  breakOut
//
//  Created by ablake on 3/9/17.
//  Copyright © 2017 Student. All rights reserved.
// Test

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate
{
    var ball: SKSpriteNode!
    var paddle: SKSpriteNode!
    var brick: SKSpriteNode!
    var blockCount = 0
    var blocksArray = [25]
    var allViewsArray = [25]
    var numberOfBlocks = 0
    var numberOfLives = 3
    var ballReset = true
    
    override func didMove(to view: SKView)
    {
        physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)// Constraints around edge
        
        createBackground()
        makeBall()
        makePaddle()
        createBlocks()
        makeLoseZone()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch in touches
        {
            let location = touch.location(in: self)
            paddle.position.x = location.x
        }
        if ballReset
        {
            ball.physicsBody?.applyImpulse(CGVector(dx: 5, dy: 5))// Puts ball in motion
            ballReset = false
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch in touches
        {
            let location = touch.location(in: self)
            paddle.position.x = location.x
        }
        if ballReset
        {
            ball.physicsBody?.applyImpulse(CGVector(dx: 5, dy: 5))// Puts ball in motion
            ballReset = false
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        if contact.bodyA.node?.name == "brick"
        {
            contact.bodyA.node?.removeFromParent()
            numberOfBlocks = numberOfBlocks - 1
            
            if numberOfBlocks == 0
            {
                levelComplete()
            }
        }
        else if contact.bodyB.node?.name == "brick"
        {
            contact.bodyB.node?.removeFromParent()
            numberOfBlocks = numberOfBlocks - 1
            
            if numberOfBlocks == 0
            {
                levelComplete()
            }
        }
        else if contact.bodyA.node?.name == "loseZone"
        {
            numberOfLives = numberOfLives - 1
            
            if numberOfBlocks == 0
            {
                youLose()
            }
        }
        else if contact.bodyB.node?.name == "loseZone"
        {
            numberOfLives = numberOfLives - 1
            
            if numberOfBlocks == 0
            {
                youLose()
            }
        }
    }
    
    func createBackground()
    {
        let stars = SKTexture(imageNamed: "stars")
        
        for i in 0...1
        {
            let starsBackground = SKSpriteNode(texture: stars)
            starsBackground.zPosition = -1
            starsBackground.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            starsBackground.position = CGPoint(x: 0, y: (starsBackground.size.height * CGFloat(i) - CGFloat(1*i)))
            
            addChild(starsBackground)
            
            let moveDown = SKAction.moveBy(x: 0, y: -starsBackground.size.height, duration: 20)
            let moveReset = SKAction.moveBy(x: 0, y: starsBackground.size.height, duration: 0)
            let moveLoop = SKAction.sequence([moveDown, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            
            starsBackground.run(moveForever)
        }
    }
    
    func makeBall()
    {
        let ballDiameter = frame.width / 20
        ball = SKSpriteNode(color: UIColor.magenta, size: CGSize(width: ballDiameter, height: ballDiameter))
        ball.position = CGPoint(x: frame.midX, y: frame.midY)
        ball.name = "ball"
        
        ball.physicsBody = SKPhysicsBody(rectangleOf: ball.size)
        ball.physicsBody?.isDynamic = true // needs to be made true at the start of the game
        ball.physicsBody?.usesPreciseCollisionDetection = true
        ball.physicsBody?.affectedByGravity = false 
        ball.physicsBody?.allowsRotation = false
        ball.physicsBody?.friction = 0
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.angularDamping = 0
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.contactTestBitMask = (ball.physicsBody?.collisionBitMask)!
        addChild(ball)
    }
    
    func makePaddle()
    {
        paddle = SKSpriteNode(color: UIColor.blue, size: CGSize(width: frame.width/3, height: frame.height/25))
        paddle.position = CGPoint(x: frame.midX, y: frame.minY + 125)
        paddle.name = "paddle"
        paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.size)
        paddle.physicsBody?.isDynamic = false
        addChild(paddle)
    }
    
    func makeBrick(xPoint: Int, yPoint: Int, brickWidth: Int, brickHeight: Int)
    {
        brick = SKSpriteNode(color: UIColor.yellow, size: CGSize(width: brickWidth, height: brickHeight))
        brick.position = CGPoint(x: xPoint, y: yPoint)
        brick.name = "brick"
        brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
        brick.physicsBody?.isDynamic = false
        addChild(brick)
    }
    
    func createBlocks()
    {
        var xPosition = Int(frame.midX - (frame.width / 2.5))
        var yPosition = 150
        
        let blockWidth = (Int)((frame.width - 60)/5)
        let blockHeight = 20
        
        for rows in 1...3
        {
            for columns in 1...5
            {
                makeBrick(xPoint: xPosition, yPoint: yPosition, brickWidth: blockWidth, brickHeight: blockHeight)
                numberOfBlocks = numberOfBlocks + 1
                xPosition += (blockWidth + 10)
            }
            xPosition = Int(frame.midX - (frame.width / 2.5))
            yPosition += (blockHeight + 10)
        }
    }
    
    func makeLoseZone()
    {
        let loseZone = SKSpriteNode(color: UIColor.red, size: CGSize(width: frame.width, height: 50))
        loseZone.position = CGPoint(x: frame.midX, y: frame.minY + 25)
        loseZone.name = "loseZone"
        loseZone.physicsBody = SKPhysicsBody(rectangleOf: loseZone.size)
        loseZone.physicsBody?.isDynamic = false
        addChild(loseZone)
    }
    
    func levelComplete()
    {
        // Displays Alert Controller
        //let alert = UIAlertController(title:"Level is complete", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        //let nextLevel = UIAlertAction(title: "Next Level", style: .default, handler: {(sender) in
            //for labels in self.labelsArray// Make the next level's brick formation in this area
            //{                             //
                //labels.text = ""          //
                //labels.canTap = true      //
            //}                             //
            //self.myGrid.xTurn = true      //
            //self.myGrid.count = 0         //
        //})
        //alert.addAction(nextLevel)
        //present(alert, animated: true, completion: nil)
    }
    
    func youLose()
    {
        
    }
}
