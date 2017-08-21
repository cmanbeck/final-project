
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
    
    var gameOverMusic: SKAudioNode!
    
//    var buttonMenu : MSButtonNode!
    
    
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
        tryAgainLabel.text = "Return to Menu"
        addChild(tryAgainLabel)
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        gameIsEnded = false
        self.view?.presentScene(MainMenu(fileNamed: "MainMenu")!)
  
        
    }
    
    
    override func didMove(to view: SKView) {

        
//        buttonMenu = self.childNode(withName: "buttonMenu") as! MSButtonNode
//        
//        buttonMenu.selectedHandler = {
//            self.loadMenu()
//            self.gameIsEnded = false
//            
//        }
        self.view?.showsPhysics = false
        self.view?.showsDrawCount = false
        self.view?.showsFPS = false
        
        if gameIsEnded == true {

            if let musicURL = Bundle.main.url(forResource: "gameOverMusic", withExtension: "mp3") {
                gameOverMusic = SKAudioNode(url: musicURL)
                addChild(gameOverMusic)
            }
        }


    }
    
//    func loadMenu() {
//        
//        // 1) Grab reference to SpriteKit view
//        guard let skView = self.view as SKView! else {
//            print("Could not get Skview")
//            return
//        }
//        
//        /* 2) Load Game scene */
//        guard let scene = MainMenu(fileNamed:"MainMenu") else {
//            print("Could not load GameScene.")
//            return
//        }
//        
//        // 3) Ensure correct aspect mode
//        scene.scaleMode = .aspectFit
//        
//        // Show debug
//        skView.showsPhysics = true
//        skView.showsDrawCount = true
//        skView.showsFPS = true
//        
//        // 4) Start game scene
//        skView.presentScene(scene)
//        
//        
//        
//    }

    
    
}
