//
//  GameScene.swift
//  Game jr.
//
//  Created by WALLS BENAJMIN A on 4/6/16.
//  Copyright (c) 2016 WALLS BENAJMIN A. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var sprite : SKSpriteNode!
    let rotateGesture = UIRotationGestureRecognizer()
    var exitButton : SKLabelNode?
    var rotationOffset : CGFloat = 0
    var shipMoving = false
    var scoreLabel : SKLabelNode!
    var gameOverText : SKLabelNode!
    var gameScore = 0
    var gameOver = false

    var timeSinceLastPhaser = NSTimeInterval(0)
    var timeUntilNextPhaser = NSTimeInterval(15)
    
    var timeSinceLastEnemy1 = NSTimeInterval(0)
    var timeUntilNextEnemy1 = NSTimeInterval(50)
    
    var timeSinceLastEnemy2 = NSTimeInterval(0)
    var timeUntilNextEnemy2 = NSTimeInterval(60)
    
    override func didMoveToView(view: SKView) {
        
        scoreLabel = self.childNodeWithName("SKLabelNodeScore") as! SKLabelNode!
        exitButton = self.childNodeWithName("SKLabelNodeExit") as! SKLabelNode!
        gameOverText = self.childNodeWithName("SKLabelNodeGameOver") as! SKLabelNode!
        
        self.physicsWorld.contactDelegate = self
        
        rotateGesture.addTarget(self, action: "rotateShip:")
        self.view!.addGestureRecognizer(rotateGesture)
        
        /* Setup your scene here */
        
        sprite = SKSpriteNode(imageNamed:"nightraiderfixed")
        
        sprite.xScale = 0.5
        sprite.yScale = 0.5
        sprite.position = CGPoint(x:200, y: 200)
        sprite.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width / 3)
        sprite.physicsBody?.categoryBitMask = PhysicsCategory.Ship
        sprite.physicsBody?.collisionBitMask = PhysicsCategory.Enemy
        sprite.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        sprite.zPosition = 99
        sprite.name = "Ship"
        
        self.addChild(sprite)
    }
    
    func rotateShip(gesture: UIRotationGestureRecognizer){
        print("rotating \(gesture.rotation)")
        
        if(gesture.state == .Changed){
            sprite!.zRotation = -gesture.rotation + rotationOffset
        }
        
        if(gesture.state == .Ended){
            rotationOffset = sprite!.zRotation
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        shipMoving = true
        
        for touch in touches {
            let location = touch.locationInNode(self)
            print("X:\(location.x) Y:\(location.y)")
            print(nodeAtPoint(location).name)
            
            if nodeAtPoint(location).name == exitButton!.name || gameOver == true{
                print("Exit clicked")
                //load game scene
                let menuScene = MainMenu(fileNamed: "MainMenu")
                
                menuScene?.scaleMode = .AspectFill
                self.view?.presentScene(menuScene!, transition: SKTransition.doorsOpenHorizontalWithDuration(0.9))
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            sprite.position = location
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        shipMoving = false
    }
    
    func createPhaserShot( nodeCalled : SKSpriteNode ){
        let phaserShot = SKSpriteNode(imageNamed: "Lazor-2") // Get a image
        var phaserSound : SKAction
        
        phaserShot.xScale = 0.1
        phaserShot.yScale = 0.1
        phaserShot.position = nodeCalled.position
        phaserShot.zPosition = nodeCalled.zPosition
        
        phaserShot.physicsBody = SKPhysicsBody(circleOfRadius: phaserShot.size.width)
        phaserShot.physicsBody?.categoryBitMask =  PhysicsCategory.PhaserShot
        
        let xDist : CGFloat
        let yDist : CGFloat
        
        
        if(nodeCalled.name == "Ship"){
            phaserSound = SKAction.playSoundFileNamed("phaserShip.wav", waitForCompletion: false)
            phaserShot.physicsBody?.collisionBitMask = PhysicsCategory.Enemy & PhysicsCategory.PhaserShot
            phaserShot.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy | PhysicsCategory.PhaserShot
            phaserShot.name = "phaser shot ship"
            
            let ninetyDegrees = degreesToRadians(90.0)
            
            
            xDist = (cos(phaserShot.zRotation) * 1000 + ninetyDegrees) + phaserShot.position.x
            yDist = (sin(phaserShot.zRotation) * 1000 + ninetyDegrees) + phaserShot.position.y
            
        }else{
            phaserSound = SKAction.playSoundFileNamed("phaserEnemy.wav", waitForCompletion: false)
            phaserShot.physicsBody?.collisionBitMask = PhysicsCategory.Ship & PhysicsCategory.PhaserShot
            phaserShot.physicsBody?.contactTestBitMask = PhysicsCategory.Ship | PhysicsCategory.PhaserShot
            phaserShot.name = "phaser shot enemy"
            phaserShot.texture = SKTexture(imageNamed: "enemyLazor")
            
            let oneEightyDegrees = degreesToRadians(180.0)
            
            xDist = phaserShot.position.x - (cos(phaserShot.zRotation) * 1000 + oneEightyDegrees)
            yDist = phaserShot.position.y - (sin(phaserShot.zRotation) * 1000 + oneEightyDegrees)
            
        }
        
        
        let moveAction = SKAction.moveTo(CGPointMake(xDist,yDist), duration: 1.5)
        let sequence = SKAction.sequence([phaserSound, moveAction, SKAction.removeFromParent()])
        
        phaserShot.runAction(sequence)
        
        addChild(phaserShot)
    }
   
    override func update(currentTime: CFTimeInterval) {
        
        //Spawn Lazers
        
        if gameOver == false{
            if(shipMoving){
                timeSinceLastPhaser += 1
                
                if timeSinceLastPhaser >= timeUntilNextPhaser {
                    createPhaserShot(sprite)
                    timeSinceLastPhaser = NSTimeInterval(0)
                }
            }
            
            //Spawn Eenemy 1
            timeSinceLastEnemy1 += 1
            
            if timeSinceLastEnemy1 >= timeUntilNextEnemy1 {
                spawnEnemy1()
                timeSinceLastEnemy1 = NSTimeInterval(0)
                
            }
            
            //Spawn Eenemy 2
            timeSinceLastEnemy2 += 1
            
            if timeSinceLastEnemy2 >= timeUntilNextEnemy2 {
                spawnEnemy2()
                timeSinceLastEnemy2 = NSTimeInterval(0)
                
            }

        }else{
            gameOverText.position = CGPointMake(529.518, 379.538)
        }
     
    }
    

    func didBeginContact(contact: SKPhysicsContact){
        print(contact.bodyA.node?.name, contact.bodyB.node?.name)
        let bodyA = contact.bodyA.node
        let bodyB = contact.bodyB.node
        let explodeSound = SKAction.playSoundFileNamed("explode.wav", waitForCompletion: false)
        var explosion = false
        
        if(bodyA?.name == "enemy" && bodyB?.name == "phaser shot ship" || bodyB?.name == "enemy" && bodyA?.name == "phaser shot ship"){
            
            self.addChild(explode(contact.contactPoint))
            
            if contact.bodyA.node != nil && contact.bodyB.node != nil{
                contact.bodyA.node!.removeFromParent()
                contact.bodyB.node!.removeFromParent()
                explosion = true
            }
            
            
            gameScore += 1
            scoreLabel.text = "Score: " + String(gameScore)
    
        }
        
        if(bodyA?.name == "enemy" && bodyB?.name == "Ship" || bodyB?.name == "enemy" && bodyA?.name == "Ship" || bodyA?.name == "Ship" && bodyB?.name == "phaser shot enemy"  || bodyB?.name == "Ship" && bodyA?.name == "phaser shot enemy"){
            self.addChild(explode(contact.contactPoint))
            
            if contact.bodyA.node != nil && contact.bodyB.node != nil{
                contact.bodyA.node!.removeFromParent()
                contact.bodyB.node!.removeFromParent()
                explosion = true
            }

            gameOver = true
            
        }
        
        if explosion{
            runAction(explodeSound)
        }
        
    }
    
    func explode(location : CGPoint)->SKEmitterNode{
        var explosion : SKEmitterNode = SKEmitterNode()
        
        if let burstPath = NSBundle.mainBundle().pathForResource("enemyExplode", ofType: "sks"){
            explosion = NSKeyedUnarchiver.unarchiveObjectWithFile(burstPath) as! SKEmitterNode
            
            explosion.position = location
            explosion.name = "enemyExplode"
            
            explosion.runAction(SKAction.sequence([SKAction.waitForDuration(0.5), SKAction.fadeAlphaTo(0.0, duration: 0.3), SKAction.removeFromParent()]))
        
        
        }
        
        return explosion
        
    }
    
    
    func spawnEnemy1(){
        
        var enemy : SKSpriteNode!
        
        enemy = SKSpriteNode(imageNamed: "shmupEnemies_1")
        enemy.setScale(1.9)
        enemy.name = "enemy"
        
        enemy.position = CGPoint(x: 884.741, y: 900.37) //Normal position
        //enemy.position = CGPoint(x: 847.67, y: 472.445) //Test Postion
        
        enemy.zPosition = 55
        
        let enemyPhysicsSize = CGSize(width: enemy.size.width,height: 45)
        enemy.physicsBody = SKPhysicsBody(rectangleOfSize: enemyPhysicsSize)
        enemy.physicsBody?.dynamic = false
        
        enemy.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        enemy.physicsBody?.collisionBitMask = PhysicsCategory.Ship
        enemy.physicsBody?.contactTestBitMask = PhysicsCategory.Ship

        
        self.addChild(enemy)
        
        let enemyMoveDown = SKAction.moveTo(CGPointMake(884.741, -186.766), duration:5)
        
        //let scaleEnemy = SKAction.scaleTo(2.5, duration: 5.6)
        
        let firePhaser = SKAction.runBlock{ self.createPhaserShot(enemy)}
        let wait = SKAction.waitForDuration(1.5)
        
        let enemyShoot = SKAction.repeatAction(SKAction.sequence([wait, firePhaser]), count: 4)
        
        enemy.runAction(enemyMoveDown)
        enemy.runAction(enemyShoot)
        
        
    }
    
    func spawnEnemy2(){
        
        var enemy : SKSpriteNode!
        
        enemy = SKSpriteNode(imageNamed: "shmupEnemies_2")
        enemy.setScale(1.9)
        enemy.name = "enemy"
        
        enemy.position = CGPoint(x: 1163.803, y: 616.023) //Normal position
        
        enemy.zPosition = 55
        
        let enemyPhysicsSize = CGSize(width: enemy.size.width,height: 45)
        enemy.physicsBody = SKPhysicsBody(rectangleOfSize: enemyPhysicsSize)
        enemy.physicsBody?.dynamic = false
        
        enemy.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        enemy.physicsBody?.collisionBitMask = PhysicsCategory.Ship
        enemy.physicsBody?.contactTestBitMask = PhysicsCategory.Ship
        
        
        self.addChild(enemy)
        
        let enemyMoveLeft = SKAction.moveTo(CGPointMake(272.87, 456.175), duration:1)
        let enemyMoveDown = SKAction.moveTo(CGPointMake(278.291, 179.645), duration:1)
        let enemyMoveRight = SKAction.moveTo(CGPointMake(1583.939, -218.92), duration:1)
        
        
        let enemyMove = SKAction.sequence([enemyMoveLeft, enemyMoveDown, enemyMoveRight ])
        
        enemy.runAction(enemyMove)
        
        
    }

    
    
}
