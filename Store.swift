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
    
    let levelData = GameHandler.sharedInstance.levelData
    
    var coin: SKSpriteNode!
    
    var coinCounter:SKLabelNode!
    
    
    var buttonMenu : MSButtonNode!
    
    var buttonBuyBlue: MSButtonNode!
    
    var shopBackgroundMusic: SKAudioNode!
    
    var inShop = true
    
    //    var buttonMenu : MSButtonNode!
    
    
   

    
    override func didMove(to view: SKView) {
    
//        coinCounter.text = "  \(GameHandler.sharedInstance.coinCounter)"
        
        self.view?.showsPhysics = false
        self.view?.showsDrawCount = false
        self.view?.showsFPS = false
        
        if inShop == true {
            if let musicURL = Bundle.main.url(forResource: "shopMusic", withExtension: "mp3") {
                shopBackgroundMusic = SKAudioNode(url: musicURL)
                addChild(shopBackgroundMusic)
            }

        }
        
        buttonMenu = self.childNode(withName: "buttonMenu") as! MSButtonNode
        
        buttonMenu.selectedHandler = {
            self.loadMenu()
            self.inShop = false
            
        }

        
//        buttonBuyBlue = self.childNode(withName: "buttonBuyBlue") as! MSButtonNode
//        
//        buttonBuyBlue.selectedHandler = {
//            
////            coinCounter -= coinCounter
//            
//        }

        
        
        
        
        

        
        

        
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
