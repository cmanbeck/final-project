//
//  Store.swift
//  Final
//
//  Created by courtney manbeck on 8/14/17.
//  Copyright © 2017 Courtney Manbeck. All rights reserved.
//

import Foundation
import SpriteKit

class Store: SKScene, SKPhysicsContactDelegate {
    
    var coin: SKSpriteNode!
    
    var coinCounter:SKLabelNode!

    
    var buttonMenu : MSButtonNode!
    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//
//    override init(size: CGSize) {
//        super.init(size: size)
//        
//        scene?.backgroundColor = SKColor.black
//        
//        coin = SKSpriteNode(imageNamed: "coin_01")
//        coin.position = CGPoint(x: 25, y: self.size.height-30)
//        addChild(coin)
//        
//        coinCounter = SKLabelNode(fontNamed: "Verdana")
//        coinCounter.fontSize = 30
//        coinCounter.fontColor = SKColor.white
//        coinCounter.position = CGPoint(x: 50, y: self.size.height-40)
//        coinCounter.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
//        
//        coinCounter.text = "  \(GameHandler.sharedInstance.coinCounter)"
//        addChild(coinCounter)
//        
//        
//        
//        
//    }

    
    override func didMove(to view: SKView) {
    
        buttonMenu = self.childNode(withName: "buttonMenu") as! MSButtonNode
        
        buttonMenu.selectedHandler = {
            self.loadMenu()
        }

        
    }
    
    func loadMenu() {
        
        // 1) Grab reference to SpriteKit view
        guard let skView = self.view as SKView! else {
            print("Could not get Skview")
            return
        }
        
        /* 2) Load Game scene */
        guard let scene = MainMenu(fileNamed:"MainMenu") else {
            print("Could not load GameScene.")
            return
        }
        
        // 3) Ensure correct aspect mode
        scene.scaleMode = .aspectFit
        
        // Show debug
        skView.showsPhysics = true
        skView.showsDrawCount = true
        skView.showsFPS = true
        
        // 4) Start game scene
        skView.presentScene(scene)

        
        
    }

    
    
}
