//
//  SwipeTracker.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 4/9/21.
//

import Foundation

class SwipeTracker {
    var gameScene: GameScene!
    static var gameSceneClass: GameScene.Type = GameScene.self
    static var constants: Constants = Constants()
    
    func showGameScenesLevelCompleteMenu() {
        if self.gameScene.grid.isLevelComplete() {
            SwipeTracker.constants.completeLevels.append(SwipeTracker.gameSceneClass.level)
            self.gameScene.showLevelCompleteMenu()
        }
    }
}

