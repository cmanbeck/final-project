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
    
    var playMusic = true
    
    var backgroundMusic: SKAudioNode!
    
    // UI connections
    var buttonPlay : MSButtonNode!
    var buttonStore: MSButtonNode!
    var buttonCredits: MSButtonNode!
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        
        
        self.view?.showsPhysics = false
        self.view?.showsDrawCount = false
        self.view?.showsFPS = false
        
        if playMusic == true {
            if let musicURL = Bundle.main.url(forResource: "Harp", withExtension: "mp3") {
                backgroundMusic = SKAudioNode(url: musicURL)
                addChild(backgroundMusic)
            }
            
        }
        
        
        /* Set UI connections */
        buttonPlay = self.childNode(withName: "buttonPlay") as! MSButtonNode
        buttonStore = self.childNode(withName: "buttonStore") as! MSButtonNode
        buttonCredits = self.childNode(withName: "buttonCredits") as! MSButtonNode
        
        buttonPlay.selectedHandler = {
            self.loadGame()
            self.playMusic = false
        }
        
        buttonStore.selectedHandler = {
            self.loadStore()
            self.playMusic = false
        }
        
        buttonCredits.selectedHandler = {
            self.loadCredits()
            self.playMusic = true
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
