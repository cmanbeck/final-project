//
//  Credits.swift
//  Final
//
//  Created by courtney manbeck on 8/14/17.
//  Copyright © 2017 Courtney Manbeck. All rights reserved.
//

import Foundation
import SpriteKit

class Credits: SKScene, SKPhysicsContactDelegate {
    
    let fixedDelta: CFTimeInterval = 1.0 / 60.0 /* 60 FPS */
    var scrollSpeed: CGFloat = 100

    
    var creditsScroll : SKNode!
    
    var buttonMenu : MSButtonNode!

    override func didMove(to view: SKView) {
        
        creditsScroll = self.childNode(withName: "creditsScroll")
        
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
    
    func scrollCredits() {
        /* Scroll World */
        
        if creditsScroll.position.y < 1505 {
            creditsScroll.position.y += scrollSpeed * CGFloat(fixedDelta) / 3
        }
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
     
        scrollCredits()
        
    }
    
    
    
    
    
}
