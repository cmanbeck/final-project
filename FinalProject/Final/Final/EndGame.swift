
import SpriteKit

class EndGame: SKScene {
    
    
    var coin: SKSpriteNode!
    
    var coinCounter:SKLabelNode!
    
    var scoreLabel:SKLabelNode!
    
    var highScoreLabel:SKLabelNode!
    
    var tryAgainLabel:SKLabelNode!
    
    
    
    
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
        
        
        scoreLabel = SKLabelNode(fontNamed: "Verdana")
        scoreLabel.fontSize = 60
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: self.size.width / 2, y: 300)
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        scoreLabel.text = "\(GameHandler.sharedInstance.score)"
        addChild(scoreLabel)
        
        
        highScoreLabel = SKLabelNode(fontNamed: "Verdana")
        highScoreLabel.fontSize = 30
        highScoreLabel.fontColor = SKColor.red
        highScoreLabel.position = CGPoint(x: self.size.width / 2, y: 450)
        highScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        highScoreLabel.text = "\(GameHandler.sharedInstance.highScore)"
        addChild(highScoreLabel)
        
        tryAgainLabel = SKLabelNode(fontNamed: "Verdana")
        tryAgainLabel.fontSize = 30
        tryAgainLabel.fontColor = SKColor.white
        tryAgainLabel.position = CGPoint(x: self.size.width / 2, y: 50)
        tryAgainLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        tryAgainLabel.text = "Play Again"
        addChild(tryAgainLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        
        self.view?.presentScene(GameScene(fileNamed: "GameScene")!)
  
        
        
    }
    
    
    
}
