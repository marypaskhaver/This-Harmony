//
//  SelectLevelViewControllerTests.swift
//  This HarmonyTests
//
//  Created by Mary Paskhaver on 4/24/21.
//

import XCTest
import SpriteKit

@testable import This_Harmony

class SelectLevelViewControllerTests: XCTestCase {
    var gvc: GameViewController!
    var slvc: SelectLevelViewController!

    override func setUpWithError() throws {
        super.setUp()
        
        gvc = MockDataModelObjects().createGameViewController()
    }
    
    func testSelectLevelViewControllerNumberOfCellsEqualsNumberOfLevels() {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        
        // Must get rootViewController like so instead of just gvc to avoid SelectLevelViewController's view not in window hierarchy error
        // Potential fix would be putting SelectViewController's layout code in viewDidAppear instead of viewDidLoad?
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }

//          topController should now be your topmost view controller
            gvc = topController as? GameViewController
            gvc.presentLevelMenu()

            slvc = topController.presentedViewController as? SelectLevelViewController
            slvc.collectionView.layoutIfNeeded()
        }
        
        XCTAssertEqual(slvc.collectionView.visibleCells.count, Constants.numLevels)
    }

}
