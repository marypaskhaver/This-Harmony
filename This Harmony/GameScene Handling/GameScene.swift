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
    
    var buttonRestart: MSButtonNode! // Create these in every scene w/ code so they don't repeat in the scene editor
    var buttonNext: MSButtonNode!
    var buttonPrevious: MSButtonNode!
    var buttonMenu: MSButtonNode!

    var levelLabel: TextLabel!
    var stepsLabel: TextLabel!
    
    static var level: Int = 1
    
    var gvc: GameViewController!
    var buttonAndLabelMaker: GameSceneButtonAndLabelMaker!

    var trackers: [SwipeTracker] = []
    
    lazy var theme: Theme = Constants().getLevelTheme()

    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        // If the user changed what player they're playing as, this will notify the theme and update the image
        self.theme.updatePlayerImageIfNeeded()

        // Create grid
        let gridCreator: GridCreator = GridCreator(withChildren: children)
        grid = Grid(with2DArrayOfTiles: gridCreator.grid, laserPointers: gridCreator.laserPointers, withCoreDataManager: gvc.cdm)
        
        let childrenToAdd: [Tile : CGPoint] = gridCreator.childrenToAddToView
        
        for child in childrenToAdd.keys { // These will always be Floors to add underneath players and crates bc there will always be a player and some crates
            child.position = childrenToAdd[child]!
            self.addChild(child)
        }
        
        // Add camera and make its position the center of the node grid
        CameraMaker(forGameScene: self).addCamera()
                
        // Set buttons-- change from hardcoded to based off screen size later
        buttonAndLabelMaker = GameSceneButtonAndLabelMaker(with: self)
        buttonAndLabelMaker.addButtonsAndLabels()
        disableButtonsIfNeeded()
        
        // Set up trackers to track UISwipeGestureRecognizers and move character, update grid when swipe occurs
        trackers = [SwipeRightTracker(for: self), SwipeLeftTracker(for: self), SwipeUpTracker(for: self), SwipeDownTracker(for: self)]
    }
    
    // Load level
    class func getLevel(_ levelNumber: Int) -> GameScene? {
        guard let scene = GameScene(fileNamed: "Level_\(levelNumber)") else {
            return nil
        }
                
        scene.scaleMode = .aspectFill
        
        // Reset music
        SoundPlayer().reset()
        
        return scene
    }
    
    func disableButtonsIfNeeded() {
        // Disable buttons if the SKS level doesn't exist or hasn't been added to Tile.constants's levelThemes
        if CoreDataManager.gameSceneClass.getLevel(CoreDataManager.gameSceneClass.level + 1) == nil ||
            Tile.constants.levelThemes[CoreDataManager.gameSceneClass.level + 1] == nil {
            buttonNext.state = .disabled
            buttonNext.reloadInputViews()
        } else if CoreDataManager.gameSceneClass.getLevel(CoreDataManager.gameSceneClass.level - 1) == nil ||
            Tile.constants.levelThemes[CoreDataManager.gameSceneClass.level - 1] == nil {
            buttonPrevious.state = .disabled
            buttonPrevious.reloadInputViews()
        }
    }
    
    func disableSwipeTrackers() {
        _ = self.view!.gestureRecognizers?.map( { $0.isEnabled = false } )
    }
    
    func goToNextLevel() {
        let nextLevel: GameScene? = CoreDataManager.gameSceneClass.getLevel(CoreDataManager.gameSceneClass.level + 1)
        
        if nextLevel != nil {
            nextLevel!.gvc = gvc
            CoreDataManager.gameSceneClass.level += 1
            self.view?.presentScene(nextLevel)
        }
        
        disableButtonsIfNeeded()
    }
    
    func goToPreviousLevel() {
        let previousLevel: GameScene? = CoreDataManager.gameSceneClass.getLevel(CoreDataManager.gameSceneClass.level - 1)
        
        if previousLevel != nil {
            previousLevel!.gvc = gvc
            CoreDataManager.gameSceneClass.level -= 1
            self.view?.presentScene(previousLevel)
        }

        disableButtonsIfNeeded()
    }
    
    func setGameSceneChangingButtonsStates(to state: MSButtonNodeState) {
        buttonRestart.state = state
        buttonNext.state = state
        buttonPrevious.state = state
    }
    
    func showPauseAndSettingsMenu() {
        let menuBox: SKShapeNode = MenuBoxMaker(for: self).getBox(ofType: .pauseLevelMenu)
                
        // Filter scene's children for any nodes w/ the name "pause-level-menu"
        let nodesNamedMenuBox: [SKNode] = children.filter { (node) -> Bool in
            node.name == MenuBox.pauseLevelMenu.rawValue
        }
        
        if nodesNamedMenuBox.count == 0 {
            menuBox.position = CGPoint(x: 0, y: UIScreen.main.bounds.maxY) // Come down from top of screen
            self.scene?.addChild(menuBox)
            menuBox.run(SKAction.moveTo(y: 0, duration: 0.8))
            
            setGameSceneChangingButtonsStates(to: .disabled)
            disableSwipeTrackers() // So user can't move while menu is open
        } else { // Pause menu already exists
            // Find it
            let existingBox: SKShapeNode = self.children.first(where: {$0.name == MenuBox.pauseLevelMenu.rawValue} ) as! SKShapeNode
            
            let sizeMultiplier: CGFloat = 1 + abs(1.0 - CGFloat(self.grid.grid[0].count) / 8.0)

            // If it's in the scene, retract it
            if scene!.intersects(existingBox) {
                // Set position to 1050 px above screen's and menuBox's height just to make sure it doesn't intersect the scene being presented. Every scene has a height of 1024 and the sizeMultiplier accounts for the camera zoom.
                
                let amtToAdd: CGFloat = grid.grid.count <= 7 ? 70 : 0
                
                existingBox.run(SKAction.moveTo(y: 1050 * sizeMultiplier + amtToAdd, duration: 0.8))
                
                setGameSceneChangingButtonsStates(to: .active)
                _ = self.view!.gestureRecognizers?.map( { $0.isEnabled = true } )
            } else {    // Else, drop it down
                existingBox.run(SKAction.moveTo(y: 0, duration: 0.8))
                
                setGameSceneChangingButtonsStates(to: .disabled)
                disableSwipeTrackers() // So user can't move while menu is open
            }
                        
        }
        
    }
    
    func showLevelCompleteMenu() {
        let menuBoxMaker: MenuBoxMaker = MenuBoxMaker(for: self)
        let menuBox: SKShapeNode = menuBoxMaker.getBox(ofType: .levelCompleteMenu)
        
        menuBox.position = CGPoint(x: 0, y: UIScreen.main.bounds.maxY) // Come down from top of screen
        self.scene?.addChild(menuBox)
        menuBox.run(SKAction.moveTo(y: 0, duration: 0.8))

        buttonRestart.state = .disabled
        buttonNext.state = .disabled
        buttonPrevious.state = .disabled
        
        grid.updateStepDataIfNeeded()
        
        disableSwipeTrackers() // So user can't move while menu is open
        disablePauseButton() // So user can't open list of levels while their level-complete data is showing
    }
    
    func disablePauseButton() {
        let nodesNamedMenuButton: [SKNode] = children.filter { (node) -> Bool in
            node.name == "menu_button"
        }
        
        ((nodesNamedMenuButton.first) as! MSButtonNode).state = .disabled
        ((nodesNamedMenuButton.first) as! MSButtonNode).reloadInputViews()
    }
    
}
