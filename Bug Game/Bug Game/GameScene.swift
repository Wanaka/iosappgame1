//
//  GameScene.swift
//  Bug Game
//
//  Created by Jonas Haag on 2017-10-07.
//  Copyright © 2017 Jonas Haag. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate
{    
    var Player = SKSpriteNode()
    var Ground = SKSpriteNode()
    var Obstacle = SKSpriteNode()
    var Enemy = SKSpriteNode()
    var Spitball = SKSpriteNode()
    var label =  SKLabelNode()
    
    let textureAtlasPlayer = SKTextureAtlas(named:"move.atlas")
    
    var playerAnimationArray = Array<SKTexture>();
    var enemyAnimationArray = Array<SKTexture>();
    
    var xPos = CGFloat(500)
    
    override func didMove(to view: SKView)
    {
        self.physicsWorld.contactDelegate = self
        backgroundColor = SKColor.white
        
        //Run everything
        runGround()
        runPlayer()
        
        randomizeObstacles(delay: 3)
//        randomizeEnemies(delay: 1.0)
        runEnemy()
    }
    
    func didBegin(_ contact: SKPhysicsContact) //See if contact has occured
    {
       let firstBody = contact.bodyA.node as!SKSpriteNode
        let secondBody = contact.bodyB.node as!SKSpriteNode

        //Player contact
        if((firstBody.name == "Player") && (secondBody.name == "Obstacle") || (firstBody.name == "Obstacle") && (secondBody.name == "Player") || (firstBody.name == "Player") && (secondBody.name == "Enemy") || (firstBody.name == "Enemy") && (secondBody.name == "Player"))
        {
            print("Player in contact with something!")
            runHitPlayer()
           
            self.run(SKAction.wait(forDuration: 1)) {
                self.scoreboard()
            }
            
        }
        
        //Spitball contact
        if((firstBody.name == "Spitball") && (secondBody.name == "Enemy") || (firstBody.name == "Enemy") && (secondBody.name == "Spitball"))
        {
            print("Spitball hit")
            
            self.runHitEnemy()
            self.Enemy.physicsBody = nil
            
            self.run(SKAction.wait(forDuration: 1)) {
                self.Enemy.removeFromParent()
            }
        }
        
    }
    
    func touchDown(atPoint pos : CGPoint) {
       
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        //make touch only affect the area regarding Player
        for touch: AnyObject in touches {
            let location = touch.location(in:self)
            if self.atPoint(location) == self.Player {
                print("player pressed!")
                
                Player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 90))
        
                
                //Restart scene
            } else if self.atPoint(location) == self.label {
            print("text label was clicked")
                
                if let view = self.view {
                    // Load the SKScene from 'GameScene.sks'
                    if let scene = SKScene(fileNamed: "GameScene") {
                        // Set the scale mode to scale to fit the window
                        scene.scaleMode = .aspectFit
                        
                        // Present the scene
                        view.presentScene(scene)
                    }
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                }
                
            }
            else{
                spitBall()
                moveSpit()
            }
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {}
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {}
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {}
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    //spawn obstacle randomly
    func randomizeObstacles(delay: TimeInterval)
    {
        removeAction(forKey: "runObstacles")
        
        let delayAction = SKAction.wait(forDuration: delay)
        let spawnAction = SKAction.run {
            self.runObstacles()
        }
        
        let sequenceAction = SKAction.sequence([delayAction, spawnAction])
        let repeatAction = SKAction.repeatForever(sequenceAction)
        
        run(repeatAction, withKey:"runObstacles")
    }
    
    //spawn enemies randomly
//    func randomizeEnemies(delay: TimeInterval)
//    {//NEED TO GET A SOLUTION ON THIS PROBLEM WHERE SPITBALL CANT HIT ANYMORE WHEN I USE DELAY FUNCTION
//        removeAction(forKey: "runEnemy")
//
//        let delayAction = SKAction.wait(forDuration: delay)
//        let spawnAction = SKAction.run {
//            self.runEnemy()
//            self.animate()
//        }
//
//        let sequenceAction = SKAction.sequence([delayAction, spawnAction])
//        let repeatAction = SKAction.repeatForever(sequenceAction)
//
//        run(repeatAction, withKey:"runEnemy")
//    }
    
    func scoreboard()
    {
        label =  SKLabelNode(text: "Restart Game")
        
        label.position = CGPoint(x: 0, y: 0)
        label.fontSize = 45
        label.fontColor = SKColor.black
        label.fontName = "Avenir"
        
        self.addChild(label)
    }
    
    func spitBall()
    {
        //Create Enemies
        Spitball = SKSpriteNode(imageNamed: "spit.png")
        
        //Scale and position
        Spitball.setScale(0.1)
        Spitball.position = CGPoint(x: Player.position.x, y: Player.position.y)
        Spitball.zPosition = 1
        
        //Physics
        //HAVE A LOOK AT THE RADIUS TO WORK WITH THE FUCKING SPITBALL NOT DYING
        Spitball.physicsBody = SKPhysicsBody(circleOfRadius: Spitball.size.width / 2)
        Spitball.physicsBody?.affectedByGravity = true
        Spitball.physicsBody?.isDynamic = true
        Spitball.physicsBody?.allowsRotation = false
        
        Spitball.physicsBody?.categoryBitMask = PhysicsCategories.Spitball
        Spitball.physicsBody?.collisionBitMask = PhysicsCategories.Enemy
        Spitball.physicsBody?.contactTestBitMask = PhysicsCategories.Enemy
        Spitball.name = "Spitball"
                
        self.addChild(Spitball)
    }
    
    func moveSpit()
    {
        //Add movement
        
        
        //START HEEREEE NEXT DEV SESSION. SEE IF SPITBALL DOESNT HIT BECAUSE I REMOVED THE APLLYIMPULSE...DONT THINK SO BUT TRY IT.
        
//        var moveSpitball = SKAction.applyImpulse(CGVector(dx:40, dy:40))
        
        
        var moveSpitball = SKAction.applyForce(CGVector(dx:40, dy:40), duration: 0.1)

        self.Spitball.run(
            SKAction.sequence([
                SKAction.wait(forDuration: 0.8),
                SKAction.removeFromParent()
                ])
        )
        
        Spitball.run(moveSpitball)
    }
    
    func runGround()
    {
        //Create "Ground"
        Ground = self.childNode(withName: "Ground") as! SKSpriteNode
        Ground.zPosition = 2
    }
    
     func runPlayer()
     {
        //Create "Player"
        Player = self.childNode(withName: "Player") as! SKSpriteNode
        Player.setScale(0.25)
        Player.zPosition = 3
        
        Player.physicsBody?.categoryBitMask = PhysicsCategories.Player
        Player.physicsBody?.collisionBitMask = PhysicsCategories.Obstacle
        Player.physicsBody?.contactTestBitMask = PhysicsCategories.Obstacle
    }
    
    func runObstacles()
    {
        //Create Obstacles
        Obstacle = SKSpriteNode(imageNamed: "obstaclePointy.png")
        
        //Scale and position
        Obstacle.setScale(0.2)
        Obstacle.position = CGPoint(x: xPos, y: self.frame.height / 2 - 350)
        Obstacle.zPosition = 1
        
        //Physics
        Obstacle.physicsBody = SKPhysicsBody(rectangleOf: Obstacle.size)
        Obstacle.physicsBody?.affectedByGravity = false
        Obstacle.physicsBody?.isDynamic = false
        Obstacle.physicsBody?.allowsRotation = false
    
        Obstacle.physicsBody?.categoryBitMask = PhysicsCategories.Obstacle
        Obstacle.physicsBody?.collisionBitMask = PhysicsCategories.Player
        Obstacle.physicsBody?.contactTestBitMask = PhysicsCategories.Player
        Obstacle.name = "Obstacle"
        
        //Add movement
        let moveObstacle = SKAction.moveTo(x: -size.width - Obstacle.size.width, duration: 7)
        
        Obstacle.run(moveObstacle)
        
        self.addChild(Obstacle)
    }
    
    func runEnemy()
    {
        let timer = SKAction.wait(forDuration: 3, withRange: 1)
        
        let spawnNode = SKAction.run {
            
            //Create Enemies
            self.Enemy = SKSpriteNode(imageNamed: "enemymove_1.png")
            
            //Scale and position
            self.Enemy.setScale(0.4)
            
            
            
            //CHANGE THE SPAWNING POSITION HERE
            let spawnLocation = CGPoint(x:Int(arc4random() % UInt32(self.frame.width + self.Enemy.size.width) ), y:Int(arc4random() %  UInt32(300)))
            
            self.Enemy.position = spawnLocation
//            self.Enemy.position = CGPoint(x: 1000, y: self.frame.height / 2 - 300)
            self.Enemy.zPosition = 1
            
            //Physics
            self.Enemy.physicsBody = SKPhysicsBody(circleOfRadius: self.Enemy.size.width / 2.0)
            self.Enemy.physicsBody?.affectedByGravity = true
            self.Enemy.physicsBody?.isDynamic = true
            self.Enemy.physicsBody?.allowsRotation = false
            
            self.Enemy.physicsBody?.categoryBitMask = PhysicsCategories.Enemy
            self.Enemy.physicsBody?.collisionBitMask = PhysicsCategories.Player
            self.Enemy.physicsBody?.contactTestBitMask = PhysicsCategories.Player
            self.Enemy.name = "Enemy"
            
            //Add movement
            let moveEnemy = SKAction.moveTo(x: (-self.size.width - self.frame.size.width), duration: 7)
            self.Enemy.run(moveEnemy)
            
            self.addChild(self.Enemy)
        }
        
        let sequence = SKAction.sequence([timer, spawnNode])
        
        
        self.run(SKAction.repeatForever(sequence) , withKey: "spawning") // run action with key so you can remove it later

        
        
        
    }
    
    func runHitPlayer()
    {
        //Remove all actions of the obstacle
//        Obstacle.removeAllActions()
        Enemy.removeAllActions()
        
        //make rotation on Player and remove grounds physics
        Player.physicsBody?.allowsRotation = true
        
        //create rotation of the dead Player
        let rotate = SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 0.3)
        Player.run(rotate)
        
        Player.physicsBody?.applyImpulse(CGVector(dx: -20, dy: 40))
       
        //Remove physics from ground, obstacle and enemy
        Ground.physicsBody = nil
        Obstacle.physicsBody = nil
        Enemy.physicsBody = nil
    }
    
    func runHitEnemy()
    {
        //make rotation on Player and remove grounds physics
        Enemy.physicsBody?.allowsRotation = true
        
        //create rotation of the dead Player
        let rotate = SKAction.rotate(byAngle: CGFloat(-Double.pi), duration: 0.3)
        Enemy.run(rotate)
        
        Enemy.physicsBody?.applyImpulse(CGVector(dx: 20, dy: 40))

    }
    
    func animate() // Animate all things here
    {
        //Create Player animation
        playerAnimationArray.append(textureAtlasPlayer.textureNamed("bugmove_1"))
        playerAnimationArray.append(textureAtlasPlayer.textureNamed("bugmove_2"))
        
        let animatePlayerAction = SKAction.animate(with: self.playerAnimationArray, timePerFrame: 0.10)
        let repeatPlayerAction = SKAction.repeatForever(animatePlayerAction)
        
        Player.run(repeatPlayerAction)
        
        guard let firstimage = UIImage(named: "enemymove_1.png"),
            let secondimage = UIImage(named: "enemymove_2.png") else {
                print("unable to resolve all images")
                return
        }
        
        let textureAtlas = SKTextureAtlas(dictionary: ["enemyimage1": firstimage,
                                                       "enemyimage2": secondimage])
        
        //Create Enemy animation
        enemyAnimationArray.append(textureAtlas.textureNamed("enemyimage1"))
        enemyAnimationArray.append(textureAtlas.textureNamed("enemyimage2"))

        let animateEnemyAction = SKAction.animate(with: self.enemyAnimationArray, timePerFrame: 0.10)
        let repeatEnemyAction = SKAction.repeatForever(animateEnemyAction)

        Enemy.run(repeatEnemyAction)
    }
}
