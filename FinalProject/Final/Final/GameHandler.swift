//
//  GameHandler.swift
//  GamePractice
//
//  Created by courtney manbeck on 7/19/17.
//  Copyright © 2017 Courtney Manbeck. All rights reserved.
//

import Foundation

class GameHandler {
    // Set up score
    var score: Int
    var highScore: Int
    var coinCounter: Int
    
    var levelData: NSDictionary!
    
    let defaults = UserDefaults.standard
    
    
    class var sharedInstance: GameHandler {
        struct Singleton {
            static let instance = GameHandler()
        }
        return Singleton.instance
    }
    
    // How the game starts out
    init() {
        score = 0
        highScore = 0
        coinCounter = 0
        highScore = defaults.integer(forKey: "highScore")
        coinCounter = defaults.integer(forKey: "coinCounter")
        
//        if let path = Bundle.main.path(forResource: "Level01", ofType: "plist") {
//            if let level = NSDictionary(contentsOfFile: path) {
//              levelData = level
//            }
//        }
    
    }
    
    
    // Record player information
    func saveGameStats() {
        highScore = max(score, highScore)
        
        defaults.set(highScore, forKey: "highScore")
        defaults.set(coinCounter, forKey: "coinCounter")
        defaults.synchronize()
        
    }
    
}
