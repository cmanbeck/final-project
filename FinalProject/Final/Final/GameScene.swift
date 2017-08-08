import SpriteKit


enum GameState {
    case title, ready, playing, gameOver
}

var died = false

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    
    let levelData = GameHandler.sharedInstance.levelData
    var gameOver = false
    
    var cameraNode: SKCameraNode!
    
    var player: SKSpriteNode!
    var movableNode : SKSpriteNode?
    
    var obstacleSource: SKNode!
    var obstacleLayer: SKNode!
    
    var greenObstacleSource: SKNode!
    var greenObstacleLayer: SKNode!
    
    var redObstacleSource: SKNode!
    var redObstacleLayer: SKNode!
    
    var foodSource: SKNode!
    var foodSourceLeft: SKNode!
    var foodSourceGold: SKNode!
    var foodSourceLeftGold: SKNode!
    var foodLayer: SKNode!
    var foodLayerLeft: SKNode!
    var goldFoodLayer: SKNode!
    var goldFoodLayerLeft: SKNode!
    var scrollLayer: SKNode!
    var bgScroll : SKNode!
    
    var diamondCoinScroll : SKNode!
//    var diamondSource: SKNode!
    var diamondCoins : SKNode!
    
    var rectangleCoins: SKNode!
    var fishCoins: SKNode!
    var coin: SKNode!
    
    
    var distance: CFTimeInterval = 0

    var scoreTimer: CFTimeInterval = 0
    var spawnTimer: CFTimeInterval = 0
    var greenSpawnTimer: CFTimeInterval = 0
    var redSpawnTimer: CFTimeInterval = 0
    var spawnFoodLeftTimer: CFTimeInterval = 0
    var spawnFoodTimer: CFTimeInterval = 0
    var spawnGoldFoodLeftTimer: CFTimeInterval = 0
    var spawnGoldFoodTimer: CFTimeInterval = 0
    var spawnDiamondTimer: CFTimeInterval = 0
    
    
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
    var coinLabel: SKLabelNode!
    
    var coinCounter: Int = 0 {
        didSet {
//            coinLabel.text = String(coinCounter)
            coinLabel.text = String(coinCounter)
        
        }
    }
    
    var defaults = UserDefaults.standard
    
    var prevScore: Int!
    var prevCoins: Int!


    
    class func level(_ levelNumber: Int) -> GameScene? {
        guard let scene = GameScene(fileNamed: "Level_\(levelNumber)") else {
            return nil
        }
        scene.scaleMode = .aspectFit
        return scene
    }

    
    func didBegin(_ contact: SKPhysicsContact) {
        
        //      bodies involved in collision
        let contactA = contact.bodyA
        let contactB = contact.bodyB
        
        //      reference physics body parent nodes
        let nodeA = contactA.node!
        let nodeB = contactB.node!
        
        
        // If the collision involves an enemy...
        if contactA.categoryBitMask == 7 || contactB.categoryBitMask == 7 {
            
            // If the collision involves the player...
            if contactA.categoryBitMask == 1 {
                
                health -= 0.5
                return
                
            }
            
            if contactB.categoryBitMask == 1 {
                
                health -= 0.5
                return
                
            }
            
        }
        
        // If the collision involves food...
        if contactA.categoryBitMask == 8 || contactB.categoryBitMask == 8 {
            
            
            // If the collision involves the player...
            if contactA.categoryBitMask == 1 {
                // Increase health and remove the food
                
                health += 0.2
                removeFood(node: nodeB)
                return
            }
            
            
            if contactB.categoryBitMask == 1 {
                
                health += 0.2
                removeFood(node: nodeA)
                return
            }
            
            
            
        }
        
        // If the collision involves gold food...
        if contactA.categoryBitMask == 9 || contactB.categoryBitMask == 9 {
            
            
            // If the collision involves the player...
            if contactA.categoryBitMask == 1 {
                // Increase health and remove the food
                
                health += 0.5
                removeFood(node: nodeB)
                return
            }
            
            
            if contactB.categoryBitMask == 1 {
                
                health += 0.5
                removeFood(node: nodeA)
                return
            }
            
            
            
        }
        
        // If the collision involves coins...
        if contactA.categoryBitMask == 16 || contactB.categoryBitMask == 16 {
            
            
            // If the collision involves the player...
            if contactA.categoryBitMask == 1 {
                
                coinCounter += 1
                removeFood(node: nodeB)
                return
            }
            
            
            if contactB.categoryBitMask == 1 {
                
                coinCounter += 1
                removeFood(node: nodeA)
                return
            }
            
            
            
        }
        
        
        // If the collision involves nodeRemover...
        if contactA.categoryBitMask == 50 || contactB.categoryBitMask == 50 {
            
            if contactA.categoryBitMask == 7 {
                nodeA.removeFromParent()
            }
            
            if contactB.categoryBitMask == 7 {
                nodeB.removeFromParent()
            }
            
        }
     

        
    }
    
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        player = self.childNode(withName: "player") as! SKSpriteNode
        scrollLayer = self.childNode(withName: "scrollLayer")
        bgScroll = self.childNode(withName: "bgScroll")
        healthBar = childNode(withName: "healthBar") as! SKSpriteNode
        obstacleSource = self.childNode(withName: "//obstacle")
        obstacleLayer = self.childNode(withName: "obstacleLayer")
        greenObstacleSource = self.childNode(withName: "//greenObstacle")
        greenObstacleLayer = self.childNode(withName: "greenObstacleLayer")
        redObstacleSource = self.childNode(withName: "//redObstacle")
        redObstacleLayer = self.childNode(withName: "redObstacleLayer")
        foodSource = self.childNode(withName: "//food")
        foodSourceLeft = self.childNode(withName: "//foodLeft")
        foodSourceGold = self.childNode(withName: "//goldFood")
        foodSourceLeftGold = self.childNode(withName: "//goldFoodLeft")
        foodLayer = self.childNode(withName: "foodLayer")
        foodLayerLeft = self.childNode(withName: "foodLayerLeft")
        goldFoodLayer = self.childNode(withName: "goldFoodLayer")
        goldFoodLayerLeft = self.childNode(withName: "goldFoodLayerLeft")
        scoreLabel = self.childNode(withName: "scoreLabel") as! SKLabelNode
        
        
        cameraNode = self.childNode(withName: "camera") as! SKCameraNode
        cameraNode.position = CGPoint(x: 159.634, y: 284.395)
        self.camera = cameraNode
        
        diamondCoinScroll = self.childNode(withName: "diamondCoinScroll")
//        diamondSource = self.childNode(withName: "//coin")
        diamondCoins = self.childNode(withName: "//diamondCoins")
//        coin = self.childNode(withName: "//coin")
        coinLabel = self.childNode(withName: "coinLabel") as! SKLabelNode
        
        
        if died == true {
//            self.camera?.xScale = 0.9
//            self.camera?.yScale = 0.9
        }
        
        
        physicsWorld.contactDelegate = self
        
    }
    
  
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        
//        for t in touches{
//            let pos = t.location(in: self)
//            player?.position = pos
//            print(player.position)
//            
//        }
        
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touches moved")

        
        for t in touches{
            let pos = t.location(in: self)
            player?.position = pos
            print(player.position)
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        player.physicsBody?.affectedByGravity = true
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            movableNode = nil
        }
    }

    
    // ************ UPDATE FUNCTION ************
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
//            gameOver()
            
            endGame()
        }
        
//        scrollWorld()
 
        updateFoodRight()
        updateFoodLeft()
        
        
   
        scrollBg()
        
        
        scoreTimer += fixedDelta
        spawnTimer+=fixedDelta
        greenSpawnTimer += fixedDelta
        redSpawnTimer += fixedDelta
        spawnFoodTimer += fixedDelta
        spawnFoodLeftTimer += fixedDelta
        spawnGoldFoodTimer += fixedDelta
        spawnGoldFoodLeftTimer += fixedDelta
        spawnDiamondTimer += fixedDelta
        
//        increaseScore()
        
        distance+=fixedDelta
        scoreLabel.text = String(Int(distance))
        
        if distance > 30 {
            distance += fixedDelta
        }
        
        if distance > 6 /* && distance < 100 */ {
            updateGreenObstacles()
        }
        
        if distance > 20 /* && distance < 120 */ {
            updateObstacles()
        }
        
        if distance > 40 /* && distance < 120 */ {
            updateRedObstacles()

        }
        
        if distance > 30 {
            updateGoldFoodRight()
            updateGoldFoodLeft()
        }
        
        if distance > 8 {
            updateDiamondCoins()
        }
        
        
        // speed up the score
        if distance > 35 {
            distance += (fixedDelta * 2)
        }
        
        if distance > 120 {
            distance += ( fixedDelta * 3 )
        }
        
    }

    
    func scrollBg() {
        /* Scroll World */
        bgScroll.position.y += scrollSpeed * CGFloat(fixedDelta) / 4
        
    }
    
    func updateObstacles() {
        /* Update Obstacles */
        
        obstacleLayer.position.x -= scrollSpeed * CGFloat(fixedDelta) * 0.5
        
        /* Loop through obstacle layer nodes */
        for obstacle in obstacleLayer.children as! [SKSpriteNode] {
            
            /* Get obstacle node position, convert node position to scene space */
            let obstaclePosition = obstacleLayer.convert(obstacle.position, to: self)
            
            /* Check if obstacle has left the scene */
            if obstaclePosition.x <= -300 {
                
                /* Remove obstacle node from obstacle layer */
                obstacle.removeFromParent()
            }
            
        }
        
        /* Time to add a new obstacle? */
        if spawnTimer >= 8 {
            
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

    func updateGreenObstacles() {
        /* Update Obstacles */
        
        greenObstacleLayer.position.x += scrollSpeed * CGFloat(fixedDelta) * 1.5
        
        /* Loop through obstacle layer nodes */
        for greenObstacle in greenObstacleLayer.children as! [SKSpriteNode] {
            
            /* Get obstacle node position, convert node position to scene space */
            let greenObstaclePosition = greenObstacleLayer.convert(greenObstacle.position, to: self)
            
            /* Check if obstacle has left the scene */
            if greenObstaclePosition.y >= 600 {
                // 23 is one half the height of an obstacle
                
                /* Remove obstacle node from obstacle layer */
                greenObstacle.removeFromParent()
            }
            
        }
        
        /* Time to add a new obstacle? */
        if greenSpawnTimer >= 2.5 {
            
            /* Create a new obstacle by copying the source obstacle */
            let newGreenObstacle = greenObstacleSource.copy() as! SKNode
            greenObstacleLayer.addChild(newGreenObstacle)
            
            /* Generate new obstacle position, start just outside screen and with a random y value */
            let randomPosition = CGPoint(x: -10, y: CGFloat.random(min: 50, max: 500))
            
            /* Convert new node position back to obstacle layer space */
            newGreenObstacle.position = self.convert(randomPosition, to: greenObstacleLayer)
            
            // Reset spawn timer
            greenSpawnTimer = 0
            
            
        }
        
    }

    
    func updateRedObstacles() {
        /* Update Obstacles */
        
        redObstacleLayer.position.x += scrollSpeed * CGFloat(fixedDelta) * 2
        
        /* Loop through obstacle layer nodes */
        for redObstacle in redObstacleLayer.children as! [SKSpriteNode] {
            
            /* Get obstacle node position, convert node position to scene space */
            let redObstaclePosition = redObstacleLayer.convert(redObstacle.position, to: self)
            
            /* Check if obstacle has left the scene */
            if redObstaclePosition.x >= 400 {
                
                /* Remove obstacle node from obstacle layer */
                redObstacle.removeFromParent()
            }
            
        }
        
        /* Time to add a new obstacle? */
        if redSpawnTimer >= 1 {
            
            /* Create a new obstacle by copying the source obstacle */
            let newRedObstacle = redObstacleSource.copy() as! SKNode
            redObstacleLayer.addChild(newRedObstacle)
            
            /* Generate new obstacle position, start just outside screen and with a random y value */
            let randomPosition = CGPoint(x: -30, y: CGFloat.random(min: 50, max: 500))
            
            /* Convert new node position back to obstacle layer space */
            newRedObstacle.position = self.convert(randomPosition, to: redObstacleLayer)
            
            // Reset spawn timer
            redSpawnTimer = 0
            
            
        }
        
    }

    
    
    func updateFoodRight() {
        //        /* Update Food */
    
                // The food should spawn at a random y position. Its direction should also be randomly determined.
                // If the RNG picks 1, the food comes from the right. If the RNG picks 2, it comes from the left.
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
        
    
        /* Time to add a new obstacle? */
        if spawnFoodTimer >= 6 {
            
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
        if spawnFoodLeftTimer >= 3 {
            
            /* Create a new obstacle by copying the source obstacle */
            let newFood = foodSourceLeft.copy() as! SKNode
            foodLayerLeft.addChild(newFood)
            
            /* Generate new obstacle position, start just outside screen and with a random y value */
            let randomPosition = CGPoint(x: -24, y: CGFloat.random(min: 50, max: 452))
            
            /* Convert new node position back to obstacle layer space */
            newFood.position = self.convert(randomPosition, to: foodLayerLeft)
            
            // Reset spawn timer
            spawnFoodLeftTimer = 0
            
            
        }
        
    }

    
    func updateGoldFoodRight() {
        
        goldFoodLayer.position.x -= scrollSpeed * CGFloat(fixedDelta)
        
        /* Loop through food layer nodes */
        for goldFood in goldFoodLayer.children as! [SKSpriteNode] {
            
            /* Get food node position, convert node position to scene space */
            let foodPosition = goldFoodLayer.convert(goldFood.position, to: self)
            
            /* Check if food has left the scene */
            if foodPosition.x <= -24 {
                
                /* Remove food node from obstacle layer */
                goldFood.removeFromParent()
                
            }
            
        }
        
        
        /* Time to add a new obstacle? */
        if spawnGoldFoodTimer >= 50 {
            
            /* Create a new obstacle by copying the source obstacle */
            let newFood = foodSourceGold.copy() as! SKNode
            goldFoodLayer.addChild(newFood)
            
            /* Generate new obstacle position, start just outside screen and with a random y value */
            let randomPosition = CGPoint(x: 352, y: CGFloat.random(min: 70, max: 472))
            
            /* Convert new node position back to obstacle layer space */
            newFood.position = self.convert(randomPosition, to: goldFoodLayer)
            
            // Reset spawn timer
            spawnGoldFoodTimer = 0
            
            
        }
        
    }
    
    func updateGoldFoodLeft() {
        
        // moves food to the right
        goldFoodLayerLeft.position.x += scrollSpeed * CGFloat(fixedDelta)
        
        /* Loop through food layer nodes */
        for goldFoodLeft in goldFoodLayerLeft.children as! [SKSpriteNode] {
            
            /* Get food node position, convert node position to scene space */
            let foodPosition = foodLayerLeft.convert(goldFoodLeft.position, to: self)
            
            /* Check if food has left the scene */
            if foodPosition.x >= 350 {
                
                /* Remove food node from obstacle layer */
                goldFoodLeft.removeFromParent()
                
            }
            
        }
        
        /* Time to add new food? */
        if spawnGoldFoodLeftTimer >= 30 {
            
            /* Create a new obstacle by copying the source obstacle */
            let newLeftGoldFood = foodSourceLeftGold.copy() as! SKNode
            goldFoodLayerLeft.addChild(newLeftGoldFood)
            
            /* Generate new obstacle position, start just outside screen and with a random y value */
            let randomPosition = CGPoint(x: -24, y: CGFloat.random(min: 50, max: 452))
            
            /* Convert new node position back to obstacle layer space */
            newLeftGoldFood.position = self.convert(randomPosition, to: foodLayerLeft)
            
            // Reset spawn timer
            spawnGoldFoodLeftTimer = 0
            
            
        }
        
    }
    
    func updateDiamondCoins() {
        /* Update Obstacles */
        
        diamondCoinScroll.position.y += scrollSpeed * CGFloat(fixedDelta)
        
        /* Loop through obstacle layer nodes */
        for diamondCoins in diamondCoinScroll.children as! [SKNode] {
            
            /* Get obstacle node position, convert node position to scene space */
            let diamondCoinPosition = diamondCoinScroll.convert(diamondCoins.position, to: self)
            
            /* Check if obstacle has left the scene */
            if diamondCoinPosition.y >= 600 {
                
                /* Remove obstacle node from obstacle layer */
                diamondCoins.removeFromParent()
            }
            
        }
        
        /* Time to add a new obstacle? */
        if spawnDiamondTimer >= 8 {
            
            /* Create a new obstacle by copying the source obstacle */
            let newObstacle = diamondCoins.copy() as! SKNode
            diamondCoinScroll.addChild(newObstacle)
            
            /* Generate new obstacle position, start just outside screen and with a random y value */
            let randomPosition = CGPoint(x: CGFloat.random(min: 70, max: 250), y: -50)
            
            /* Convert new node position back to obstacle layer space */
            newObstacle.position = self.convert(randomPosition, to: diamondCoinScroll)
            
            // Reset spawn timer
            spawnDiamondTimer = 0
            
            
        }
        
    }


    
    // A function to remove food
    func removeFood( node: SKNode ) {
        let foodRemoval = SKAction.run({
            node.removeFromParent()
            
        })
        self.run(foodRemoval)
        
        
    }
    
    func endGame() {
        gameOver = true
        GameHandler.sharedInstance.saveGameStats()
        
        state = .gameOver
        
        let currentScore = Int(scoreLabel.text!)
        let currentCoins = Int(coinLabel.text!)
        
        prevScore = defaults.integer(forKey: "storedScore")
        prevCoins = defaults.integer(forKey: "coinCounter")
        
        if (currentScore! > prevScore){
            defaults.set(currentScore, forKey: "storedScore")
            
        }
        
        let totalCoins = currentCoins! + prevCoins
        
        defaults.set(totalCoins, forKey: "coinCounter")
            
        
        died = true
        /* Make the player turn red */
//        player.run(SKAction.colorize(with: UIColor.red, colorBlendFactor: 1.0, duration: 0.50))

        
        let transition = SKTransition.fade(withDuration: 0.5)
        let endGameScene = EndGame(size: self.size)
        
        endGameScene.coinCounter.text = String(defaults.integer(forKey: "coinCounter"))
        endGameScene.scoreLabel.text = scoreLabel.text
        endGameScene.highScoreLabel.text = String(defaults.integer(forKey: "storedScore"))
        self.view?.presentScene(endGameScene, transition: transition)
        
        
        
    }
    
    
    
}
