//
//  SwipeDownTracker.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 3/19/21.
//

import UIKit

class SwipeDownTracker: SwipeTracker {
    
    init(for gameScene: GameScene) {
        super.init()
        
        self.gameScene = gameScene
        
        let swipeDown: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedDown(sender:)))
        swipeDown.direction = .down
        
        self.gameScene.view!.addGestureRecognizer(swipeDown)
    }
    
    @objc func swipedDown(sender: UISwipeGestureRecognizer) {
        self.gameScene.grid.movePlayer(inDirection: .down)
        self.gameScene.stepsLabel.text = "Steps: \(self.gameScene.grid.currentSteps)"
        
        super.showGameScenesLevelCompleteMenu()
    }
}
