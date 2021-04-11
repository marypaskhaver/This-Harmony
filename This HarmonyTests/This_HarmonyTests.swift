//
//  This_HarmonyTests.swift
//  This HarmonyTests
//
//  Created by Mary Paskhaver on 12/29/20.
//

import XCTest
import SpriteKit

@testable import This_Harmony

class This_HarmonyTests: XCTestCase {
    var gc: GameViewController!
    
    override func setUpWithError() throws {
        super.setUp()
        
        gc = MockDataModelObjects().createGameViewController()
    }
    
    func testLevel1GridExists() {
        let scene: GameScene = (gc.view as! SKView).scene as! GameScene
        XCTAssertNotNil(scene.grid)
    }
    
    func testCantGoToPrevLevelFromLevel1() {
        var scene: GameScene = (gc.view as! SKView).scene as! GameScene
        XCTAssert(scene.buttonPrevious.state == .disabled)
        
        scene.goToNextLevel()
        
        // When the next level is loaded, a new GameScene is presented in GameScene's view
        scene = (gc.view as! SKView).scene as! GameScene
        XCTAssert(scene.buttonPrevious.state == .active)
    }
    
    func testCantGoToNextLevelFromLastLevel() {
        gc.loadLevel(number: Constants.numLevels) // Currently the last level
        var scene: GameScene = (gc.view as! SKView).scene as! GameScene
        XCTAssert(scene.buttonNext.state == .disabled)

        scene.goToPreviousLevel()

        // When the previous level is loaded, a new GameScene is presented in GameScene's view
        scene = (gc.view as! SKView).scene as! GameScene
        XCTAssert(scene.buttonNext.state == .active)
    }
    
    func testStepDataIsLoadedWhenLevelResets() {
        // Default # of lowestSteps stored in CoreData is Int32.max
        let scene: GameScene = (gc.view as! SKView).scene as! GameScene
        
        XCTAssert(gc.cdm.fetchCompletedLevelWithLowestSteps().lowestSteps == Int32.max)

        scene.grid.currentSteps = 10 // Current steps are lower than previously saved lowestSteps-- user beat the level in less moves
        scene.grid.lowestSteps = 20 // So 10 should be saved as new lowestSteps
        
        scene.showLevelCompleteMenu()
                
        XCTAssert(gc.cdm.fetchCompletedLevelWithLowestSteps().lowestSteps == 10) // Check if 10 is saved to lowestSteps
        XCTAssert(scene.grid.lowestSteps == 10)
        
        // Reload level
        gc.loadLevel(number: GameScene.level)
        
        XCTAssert(gc.cdm.fetchCompletedLevelWithLowestSteps().lowestSteps == 10)
        XCTAssert(scene.grid.lowestSteps == 10)
        XCTAssert(scene.grid.currentSteps == 0)
    }
    
    func testStepDataGetsUpdatedWhenLevelIsCompletedInFewerSteps() {
        // Default # of lowestSteps stored in CoreData is Int32.max
        let scene: GameScene = (gc.view as! SKView).scene as! GameScene
        
        XCTAssert(gc.cdm.fetchCompletedLevelWithLowestSteps().lowestSteps == Int32.max)

        scene.grid.currentSteps = 10 // Current steps are lower than previously saved lowestSteps-- user beat the level in less moves
        scene.grid.lowestSteps = 20 // So 10 should be saved as new lowestSteps
        
        scene.showLevelCompleteMenu()
                
        XCTAssert(gc.cdm.fetchCompletedLevelWithLowestSteps().lowestSteps == 10)
        XCTAssert(scene.grid.lowestSteps == 10)
        XCTAssert(scene.grid.currentSteps == 0)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

}
