//
//  MockDataModelObjects.swift
//  This HarmonyTests
//
//  Created by Mary Paskhaver on 4/9/21.
//

import UIKit
import SpriteKit
import CoreData

@testable import This_Harmony

class MockDataModelObjects {
    
    lazy var managedObjectModel: NSManagedObjectModel = {
            let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))] )!
            return managedObjectModel
        }()
        
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel", managedObjectModel: self.managedObjectModel)
        
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false // Make it simpler in test env
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            // Check if the data store is in memory
            precondition( description.type == NSInMemoryStoreType )
                                        
            // Check if creating container wrong
            if let error = error {
                fatalError("Create an in-mem coordinator failed \(error)")
            }
        }
    
        return container
    }()
    
    func createGameViewController() -> GameViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let gc: GameViewController = storyboard.instantiateViewController(identifier: "GameViewController") as! GameViewController
        gc.loadViewIfNeeded()
        
        gc.gameSceneClass = MockGameScene.self
        gc.cdm = CoreDataManager(container: persistentContainer)

        return gc
    }
    
    class MockGameScene: GameScene {
        
        override class func getLevel(_ levelNumber: Int) -> GameScene? {
            guard let scene = GameScene(fileNamed: "Test_Level_\(levelNumber)") else {
                print("No test level found w/ name: Test_Level_\(levelNumber)")
                return nil
            }
                    
            scene.scaleMode = .aspectFill
            return scene
        }
    }
    
    class MockConstants: Constants {
        init() {
            super.init(withCoreDataManager: CoreDataManager(container: MockDataModelObjects().persistentContainer))
            initMockProperties()
        }
                
        func initMockProperties() {
            let resourceURL = Bundle.main.resourceURL!
            let resourcesContent = (try? FileManager.default.contentsOfDirectory(at: resourceURL, includingPropertiesForKeys: nil)) ?? []
            let levelCount = resourcesContent.filter { $0.lastPathComponent.hasPrefix("Test_Level_") }.count

            self.numLevels = levelCount

            self.levelThemes = [
                1 : Beach(),
                2 : Beach(),
                3 : Beach(),
                4 : Beach(),
                5 : Beach(),
                6 : Beach(),
                7 : Beach(),
                8 : Beach(),
                9 : Beach(),
                10 : Beach(),
                11 : Beach(),
                12 : Beach()
            ]
        }
        
    }
}
