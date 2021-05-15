//
//  MenuTests.swift
//  This HarmonyTests
//
//  Created by Mary Paskhaver on 5/14/21.
//

import XCTest
import SpriteKit

@testable import This_Harmony

class MenuTests: XCTestCase {
    var gvc: GameViewController!

    override func setUpWithError() throws {
        super.setUp()
        
        CoreDataManager.gameSceneClass = MockDataModelObjects.MockGameScene.self
        gvc = MockDataModelObjects().createGameViewController()
        Floor.defaultTexture = SKTexture(imageNamed: Constants.TileNames.floor.rawValue)
    }
    
    override func tearDownWithError() throws {
        CoreDataManager.gameSceneClass.level = 1
        gvc.gameSceneClass.level = 1 // Resets GameScene or MockGameScene level to default number: 1
        gvc = nil
    }
    
    func testLevelCompleteMenuShowsWhenLevelComplete() {
        let swipeTrackerConstants: MockDataModelObjects.MockConstants = MockDataModelObjects.MockConstants(withCoreDataManager: gvc.cdm)

        SwipeTracker.constants = swipeTrackerConstants
        Player.constants = swipeTrackerConstants

        gvc.loadLevel(number: 7)
        
        let scene: GameScene = (gvc.view as! SKView).scene as! GameScene
        
        var menuBoxes = scene.children.filter( { $0.name == MenuBox.levelCompleteMenu.rawValue } )
        XCTAssertEqual(menuBoxes.count, 0)

        // Have player push crate down onto only storage space
        let swipeDownTracker: SwipeDownTracker = scene.trackers.filter( { type(of: $0) == SwipeDownTracker.self } )[0] as! SwipeDownTracker
        swipeDownTracker.swipedDown(sender: UISwipeGestureRecognizer())

        menuBoxes = scene.children.filter( { $0.name == MenuBox.levelCompleteMenu.rawValue } )

        XCTAssertEqual(menuBoxes.count, 1)
        XCTAssertTrue(scene.intersects(menuBoxes[0]))
    }

}
