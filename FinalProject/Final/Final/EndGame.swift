
import SpriteKit

class EndGame: SKScene {
    
    var coin: SKSpriteNode!
    
    var coinCounter:SKLabelNode!
    
    var scoreLabelText: SKLabelNode!
    
    var scoreLabel:SKLabelNode!
    
    var highScoreLabelText: SKLabelNode!
    
    var highScoreLabel:SKLabelNode!
    
    var deadFish: SKSpriteNode!
    
    var tryAgainLabel:SKLabelNode!
    
    var gameIsEnded: Bool = true
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        scene?.backgroundColor = SKColor.black
        
        coin = SKSpriteNode(imageNamed: "coin_01")
        coin.position = CGPoint(x: 25, y: self.size.height-30)
        addChild(coin)
        
        coinCounter = SKLabelNode(fontNamed: "Verdana")
        coinCounter.fontSize = 30
        coinCounter.fontColor = SKColor.white
        coinCounter.position = CGPoint(x: 50, y: self.size.height-40)
        coinCounter.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        
        coinCounter.text = "  \(GameHandler.sharedInstance.coinCounter)"
        addChild(coinCounter)
        
        scoreLabelText = SKLabelNode(fontNamed: "Verdana")
        scoreLabelText.fontSize = 30
        scoreLabelText.fontColor = SKColor.white
        scoreLabelText.position = CGPoint(x: self.size.width / 2, y: 450)
        scoreLabelText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        scoreLabelText.text = "Score:"
        addChild(scoreLabelText)
        
        scoreLabel = SKLabelNode(fontNamed: "Verdana")
        scoreLabel.fontSize = 30
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: self.size.width / 2, y: 420)
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        scoreLabel.text = "\(GameHandler.sharedInstance.score)"
        addChild(scoreLabel)
        
        highScoreLabelText = SKLabelNode(fontNamed: "Verdana")
        highScoreLabelText.fontSize = 30
        highScoreLabelText.fontColor = SKColor.white
        highScoreLabelText.position = CGPoint(x: self.size.width / 2, y: 350)
        highScoreLabelText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        highScoreLabelText.text = "High Score:"
        addChild(highScoreLabelText)
        
        highScoreLabel = SKLabelNode(fontNamed: "Verdana")
        highScoreLabel.fontSize = 30
        highScoreLabel.fontColor = SKColor.white
        highScoreLabel.position = CGPoint(x: self.size.width / 2, y: 320)
        highScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        highScoreLabel.text = "\(GameHandler.sharedInstance.highScore)"
        addChild(highScoreLabel)
        
        deadFish = SKSpriteNode(imageNamed: "piranha_dead")
        deadFish.position = CGPoint(x: self.size.width / 2, y: 240 )
        addChild(deadFish)
        
        tryAgainLabel = SKLabelNode(fontNamed: "Verdana")
        tryAgainLabel.fontSize = 30
        tryAgainLabel.fontColor = SKColor.white
        tryAgainLabel.position = CGPoint(x: self.size.width / 2, y: 50)
        tryAgainLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        tryAgainLabel.text = "Play Again"
        addChild(tryAgainLabel)
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        gameIsEnded = false
        self.view?.presentScene(GameScene(fileNamed: "GameScene")!)
  
        
        
    }
    
    
    override func didMove(to view: SKView) {

        
        if gameIsEnded == true {

            let sound = SKAction.playSoundFileNamed("gameOverMusic.mp3", waitForCompletion: false)
            self.run(sound)
            
        }


    }
    
    
}
