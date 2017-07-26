

import SpriteKit


enum GameState {
    case title, ready, playing, gameOver
}

class GameScene: SKScene {
    
    var player: SKSpriteNode!
    var obstacleSource: SKNode!
    var obstacleLayer: SKNode!
    var scrollLayer: SKNode!
    var spawnTimer: CFTimeInterval = 0
    let fixedDelta: CFTimeInterval = 1.0 / 60.0 /* 60 FPS */
    var scrollSpeed: CGFloat = 100
    
    var state: GameState = .title

    
    var health: CGFloat = 1.0 {
        didSet{
            // Scale health bar between 0.0 -> 1.0
            healthBar.xScale = health
            
            if health > 1.0 {
                health = 0.90
            }
        }
    }
    
    var healthBar: SKSpriteNode!
    
    func didBegin(_ contact: SKPhysicsContact) {
        //        if the player touches something, the game ends
        
        //      bodies involved in collision
        let contactA = contact.bodyA
        let contactB = contact.bodyB
        
        //      reference physics body parent nodes
        let nodeA = contactA.node!
        let nodeB = contactB.node!
        
        if ( nodeA.name == "food" ) && ( nodeB.name == "player" ) {

            print("Player touched food!")
            health += 0.5
            return
            
        }
    }
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        player = self.childNode(withName: "player") as! SKSpriteNode
        scrollLayer = self.childNode(withName: "scrollLayer")
        healthBar = childNode(withName: "healthBar") as! SKSpriteNode
        obstacleSource = self.childNode(withName: "obstacle")
        obstacleLayer = self.childNode(withName: "obstacleLayer")
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
//        player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 100))
        
        for t in touches{
            let node = atPoint(t.location(in: self))
            
            if node.name == "bottom"{
             
                player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 100))
                
            }
            
            if node.name == "top"{
                
                player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -100))
                
            }
            
            if node.name == "left"{
                
                player.physicsBody?.applyImpulse(CGVector(dx: 100, dy: 0))
                
            }
            
            if node.name == "right"{
                
                player.physicsBody?.applyImpulse(CGVector(dx: -100, dy: 0))
                
            }

            
            if node.name == "bottomLeft"{
                
                player.physicsBody?.applyImpulse(CGVector(dx: 100, dy: 100))
                
            }

            
            if node.name == "bottomRight"{
                
                player.physicsBody?.applyImpulse(CGVector(dx: -100, dy: 100))
                
            }



        }
        
    }
    

    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        
        /* Grab current velocity */
        let velocityY = player.physicsBody?.velocity.dy ?? 0
        
        player.physicsBody?.applyAngularImpulse(1)
        
        
        /* Check and cap vertical velocity */
        if velocityY > 200 {
            player.physicsBody?.velocity.dy = 200
        
        }
        
        // Decrease health
        health -= 0.001
        if health < 0 {
            health = 0
            gameOver()
        }

        
        scrollWorld()
        updateObstacles()
        spawnTimer+=fixedDelta
        
        
    }
    
    func gameOver() {
        /* Game over! */
        
        state = .gameOver
        
        
        
        /* Make the player turn red */
        player.run(SKAction.colorize(with: UIColor.red, colorBlendFactor: 1.0, duration: 0.50))
        
//        /* Change play button selection handler */
//        playButton.selectedHandler = {
//            
//            /* Grab reference to the SpriteKit view */
//            let skView = self.view as SKView!
//            
//            /* Load Game scene */
//            guard let scene = GameScene(fileNamed:"GameScene") as GameScene! else {
//                return
//            }
//            
//            /* Ensure correct aspect mode */
//            scene.scaleMode = .aspectFill
//            
//            /* Restart GameScene */
//            skView?.presentScene(scene)
//        }
    }

    
    func scrollWorld() {
        /* Scroll World */
        scrollLayer.position.y += scrollSpeed * CGFloat(fixedDelta)
        
        /* Loop through scroll layer nodes */
        for wall in scrollLayer.children as! [SKSpriteNode] {
            
            /* Get wall node position, convert node position to scene space */
            let wallPosition = scrollLayer.convert(wall.position, to: self)
            
            /* Check if wall sprite has left the scene */
            if wallPosition.y >= CGFloat(1100) /*( -wall.size.height / 2 )*/ {
                
                /* Reposition wall sprite to the second starting position */
                let newPosition = CGPoint(x: wallPosition.x, y: -840)//CGPoint(x: (self.size.height / 2) + wall.size.height, y: wallPosition.y)
                
                /* Convert new node position back to scroll layer space */
                wall.position = self.convert(newPosition, to: scrollLayer)
            }
        }

        
        
    }
    
    func updateObstacles() {
        /* Update Obstacles */
        
        obstacleLayer.position.x -= scrollSpeed * CGFloat(fixedDelta)
        
        /* Loop through obstacle layer nodes */
        for obstacle in obstacleLayer.children as! [SKSpriteNode] {
            
            /* Get obstacle node position, convert node position to scene space */
            let obstaclePosition = obstacleLayer.convert(obstacle.position, to: self)
            
            /* Check if obstacle has left the scene */
            if obstaclePosition.x <= -26 {
                // 26 is one half the width of an obstacle
                
                /* Remove obstacle node from obstacle layer */
                obstacle.removeFromParent()
            }
            
        }
     
//        /* Time to add a new obstacle? */
//        if spawnTimer >= 1.5 {
//            
//            /* Create a new obstacle by copying the source obstacle */
//            let newObstacle = obstacleSource.copy() as! SKNode
//            obstacleLayer.addChild(newObstacle)
//            
//            /* Generate new obstacle position, start just outside screen and with a random y value */
//            let randomPosition = CGPoint(x: 352, y: CGFloat.random(min: 234, max: 382))
//            
//            /* Convert new node position back to obstacle layer space */
//            newObstacle.position = self.convert(randomPosition, to: obstacleLayer)
//            
//            // Reset spawn timer
//            spawnTimer = 0
//
//        
//        }
        
    }
    
}

