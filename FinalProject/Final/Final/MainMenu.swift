//
//  MainMenu.swift
//  PeevedPenguins
//
//  Created by courtney manbeck on 7/7/17.
//  Copyright © 2017 Courtney Manbeck. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenu: SKScene {
    
    // UI connections
    var buttonPlay : MSButtonNode!
    var buttonStore: MSButtonNode!
    var buttonCredits: MSButtonNode!
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        /* Set UI connections */
        buttonPlay = self.childNode(withName: "buttonPlay") as! MSButtonNode
        buttonStore = self.childNode(withName: "buttonStore") as! MSButtonNode
        buttonCredits = self.childNode(withName: "buttonCredits") as! MSButtonNode
        
        buttonPlay.selectedHandler = {
            self.loadGame()
        }
        
        buttonStore.selectedHandler = {
            self.loadStore()
        }
        
        buttonCredits.selectedHandler = {
            self.loadCredits()
        }
        
    }
    
    func loadGame() {
        
        // 1) Grab reference to SpriteKit view
        guard let skView = self.view as SKView! else {
            print("Could not get Skview")
            return
        }
        
        /* 2) Load Game scene */
        guard let scene = GameScene(fileNamed:"GameScene") else {
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
    
    func loadStore() {
        
        // 1) Grab reference to SpriteKit view
        guard let skView = self.view as SKView! else {
            print("Could not get Skview")
            return
        }
        
        /* 2) Load Game scene */
        guard let scene = Store(fileNamed:"Store") else {
            print("Could not load Store.")
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
    
    func loadCredits() {
        
        // 1) Grab reference to SpriteKit view
        guard let skView = self.view as SKView! else {
            print("Could not get Skview")
            return
        }
        
        /* 2) Load Game scene */
        guard let scene = Credits(fileNamed:"Credits") else {
            print("Could not load Credits.")
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
