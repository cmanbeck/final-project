

import SpriteKit


enum GameState {
    case title, ready, playing, gameOver
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: SKSpriteNode!
    var obstacleSource: SKNode!
    var obstacleLayer: SKNode!
    var foodSource: SKNode!
    var foodLayer: SKNode!
    var foodLayerLeft: SKNode!
    var scrollLayer: SKNode!
    var spawnTimer: CFTimeInterval = 0
    var spawnFoodLeftTimer: CFTimeInterval = 0
    var spawnFoodTimer: CFTimeInterval = 0
    let fixedDelta: CFTimeInterval = 1.0 / 60.0 /* 60 FPS */
    var scrollSpeed: CGFloat = 100
    
    var state: GameState = .title

    
    var health: CGFloat = 1.0 {
        didSet{
            // Scale health bar between 0.0 -> 1.0
            healthBar.xScale = health
            
            if health > 1.66 {
                health = 1.60
            }
        }
    }
    
    var healthBar: SKSpriteNode!
    
    var scoreLabel: SKLabelNode!
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = String(score)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        //      bodies involved in collision
        let contactA = contact.bodyA
        let contactB = contact.bodyB
        
        //      reference physics body parent nodes
        let nodeA = contactA.node!
        let nodeB = contactB.node!
        
        // If the collision involves food...
        if contactA.categoryBitMask == 8 || contactB.categoryBitMask == 8 {

            
            // If the collision involves the player...
            if contactA.categoryBitMask == 1 {
                // Increase health and remove the food
      
                health += 0.1
                removeFood(node: nodeB)
                return
            }
            
            
            if contactB.categoryBitMask == 1 {
       
                health += 0.1
                removeFood(node: nodeA)
                return
            }
            
            
            
        }
    }

    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        player = self.childNode(withName: "//player") as! SKSpriteNode
        scrollLayer = self.childNode(withName: "scrollLayer")
        healthBar = childNode(withName: "healthBar") as! SKSpriteNode
        obstacleSource = self.childNode(withName: "//obstacle")
        obstacleLayer = self.childNode(withName: "obstacleLayer")
        foodSource = self.childNode(withName: "//food")
        foodLayer = self.childNode(withName: "foodLayer")
        foodLayerLeft = self.childNode(withName: "foodLayerLeft")
        scoreLabel = self.childNode(withName: "scoreLabel") as! SKLabelNode
        
        physicsWorld.contactDelegate = self
        
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
                
                player.physicsBody?.applyImpulse(CGVector(dx: 70.71, dy: 70.71))
                
            }

            
            if node.name == "bottomRight"{
                
                player.physicsBody?.applyImpulse(CGVector(dx: -70.71, dy: 70.71))
                
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
        score += 1

        
        scrollWorld()
        
//        let randomNum = Int(arc4random_uniform(2) + 1)
        
//                if ( randomNum == 1 ) {
                    updateFoodRight()
        
//                }
//                else {
                     updateFoodLeft()
//                }
        

        
       
        updateObstacles()
        
        spawnTimer+=fixedDelta
        spawnFoodTimer += fixedDelta
        spawnFoodLeftTimer += fixedDelta
        
        
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
            if obstaclePosition.y <= -35 {
                // 23 is one half the height of an obstacle
                
                /* Remove obstacle node from obstacle layer */
                obstacle.removeFromParent()
            }
            
        }
     
        /* Time to add a new obstacle? */
        if spawnTimer >= 3.5 {
            
            /* Create a new obstacle by copying the source obstacle */
            let newObstacle = obstacleSource.copy() as! SKNode
            obstacleLayer.addChild(newObstacle)
            
            /* Generate new obstacle position, start just outside screen and with a random y value */
            let randomPosition = CGPoint(x: 352, y: CGFloat.random(min: 100, max: 382))
            
            /* Convert new node position back to obstacle layer space */
            newObstacle.position = self.convert(randomPosition, to: obstacleLayer)
            
            // Reset spawn timer
            spawnTimer = 0

        
        }
        
    }

    
    func updateFoodRight() {
//        /* Update Food */
//        
//        let randomNum = Int(arc4random_uniform(2) + 1)
//        
//        if randomNum == 1 {
//            foodLayer.position.x -= scrollSpeed * CGFloat(fixedDelta)
//            
//        }
//        else {
//            foodLayer.position.x += scrollSpeed * CGFloat(fixedDelta)
//        }
//        
//        
//        // The food should spawn at a random y position. Its direction should also be randomly determined.
//        // If the RNG picks 1, the food comes from the right. If the RNG picks 2, it comes from the left.
//        
        foodLayer.position.x -= scrollSpeed * CGFloat(fixedDelta)
        
        /* Loop through food layer nodes */
        for food in foodLayer.children as! [SKSpriteNode] {
            
            /* Get food node position, convert node position to scene space */
            let foodPosition = foodLayer.convert(food.position, to: self)
            
            /* Check if food has left the scene */
            if foodPosition.x <= -24 {
                                
                /* Remove food node from obstacle layer */
                food.removeFromParent()
            
            }
            
        }

//        foodLayer.position.y += scrollSpeed * CGFloat(fixedDelta)
//        
//        /* Loop through scroll layer nodes */
//        for food in foodLayer.children as! [SKSpriteNode] {
//            
//            /* Get wall node position, convert node position to scene space */
//            let foodPosition = foodLayer.convert(food.position, to: self)
//            
//            /* Check if wall sprite has left the scene */
//            if foodPosition.y >= CGFloat(1100) /*( -wall.size.height / 2 )*/ {
//                
//                /* Reposition wall sprite to the second starting position */
//                let newFoodPosition = CGPoint(x: foodPosition.x, y: -840)//CGPoint(x: (self.size.height / 2) + wall.size.height, y: wallPosition.y)
//                
//                /* Convert new node position back to scroll layer space */
//                food.position = self.convert(newFoodPosition, to: scrollLayer)
//            }
//        }

        
        /* Time to add a new obstacle? */
        if spawnFoodTimer >= 1 {
            
            /* Create a new obstacle by copying the source obstacle */
            let newFood = foodSource.copy() as! SKNode
            foodLayer.addChild(newFood)
            
            /* Generate new obstacle position, start just outside screen and with a random y value */
            let randomPosition = CGPoint(x: 352, y: CGFloat.random(min: 70, max: 472))
            
            /* Convert new node position back to obstacle layer space */
            newFood.position = self.convert(randomPosition, to: foodLayer)
            
            // Reset spawn timer
            spawnFoodTimer = 0
            
            
        }
        
    }

    func updateFoodLeft() {

        // moves food to the right
        foodLayerLeft.position.x += scrollSpeed * CGFloat(fixedDelta)
        
        /* Loop through food layer nodes */
        for foodLeft in foodLayerLeft.children as! [SKSpriteNode] {
            
            /* Get food node position, convert node position to scene space */
            let foodPosition = foodLayerLeft.convert(foodLeft.position, to: self)
            
            /* Check if food has left the scene */
            if foodPosition.x >= 350 {
                
                /* Remove food node from obstacle layer */
                foodLeft.removeFromParent()
                
            }
            
        }
        
        /* Time to add new food? */
        if spawnFoodLeftTimer >= 0.6 {
            
            /* Create a new obstacle by copying the source obstacle */
            let newFood = foodSource.copy() as! SKNode
            foodLayerLeft.addChild(newFood)
            
            /* Generate new obstacle position, start just outside screen and with a random y value */
            let randomPosition = CGPoint(x: -24, y: CGFloat.random(min: 50, max: 452))
            
            /* Convert new node position back to obstacle layer space */
            newFood.position = self.convert(randomPosition, to: foodLayerLeft)
            
            // Reset spawn timer
            spawnFoodLeftTimer = 0
            
            
        }
        
    }

    
    // A function to remove food
    func removeFood( node: SKNode ) {
            let foodRemoval = SKAction.run({
            node.removeFromParent()
            
        })
        self.run(foodRemoval)
        
        
    }

    
    
    
    
}

