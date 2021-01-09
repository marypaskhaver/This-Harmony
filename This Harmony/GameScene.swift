//
//  GameScene.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 12/29/20.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var grid: Grid!
    // Can add vars holding "floorType" and "wallType" to change the images of floors and walls if there are multiple kinds of floors and walls;
    // this means that every level will have the same floor and same walls across that whole level, though diff. levels can have diff. floors and walls
    var buttonRestart: MSButtonNode!
    var buttonNext: MSButtonNode!
    static var level: Int = 1
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        // Create grid
        let gridCreator: GridCreator = GridCreator()
        grid = Grid(with2DArrayOfTiles: gridCreator.getGridOfScenesChildren(children))
        
        let childrenToAdd: [Floor : CGPoint] = gridCreator.childrenToAddToView
        
        for child in childrenToAdd.keys { // These will always be Floors to add underneath players and crates bc there will always be a player and some crates
            child.position = childrenToAdd[child]!
            self.addChild(child)
        }
        
        // Set buttons
        buttonRestart = self.childNode(withName: "buttonRestart") as! MSButtonNode
        buttonNext = self.childNode(withName: "buttonNext") as! MSButtonNode

        buttonRestart.selectedHandler = {
            self.view!.presentScene(GameScene.getLevel(GameScene.level))
        }
        
        buttonNext.selectedHandler = {
            self.goToNextLevel()
        }
                
        let swipeRight: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedRight(sender:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)

        let swipeLeft: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedLeft(sender:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)

        let swipeUp: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedUp(sender:)))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)

        let swipeDown: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedDown(sender:)))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
    }
        
    @objc func swipedRight(sender: UISwipeGestureRecognizer) {
        grid?.movePlayer(inDirection: .right)
    }
    
    @objc func swipedLeft(sender: UISwipeGestureRecognizer) {
        grid?.movePlayer(inDirection: .left)
    }
    
    @objc func swipedUp(sender: UISwipeGestureRecognizer) {
        grid?.movePlayer(inDirection: .up)
    }
    
    @objc func swipedDown(sender: UISwipeGestureRecognizer) {
        grid?.movePlayer(inDirection: .down)
    }
    
    // Load level
    class func getLevel(_ levelNumber: Int) -> GameScene? {
        guard let scene = GameScene(fileNamed: "Level_\(levelNumber)") else {
            print("Cannot find level \(levelNumber)")
            return nil
        }
        
        scene.scaleMode = .aspectFill
        return scene
    }
    
    func goToNextLevel() {
        let nextLevel: GameScene? = GameScene.getLevel(GameScene.level + 1)
        
        if nextLevel != nil {
            GameScene.level += 1
            self.view?.presentScene(nextLevel)
        }
    }
    
}
