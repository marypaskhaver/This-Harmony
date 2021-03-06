//
//  GameViewController.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 12/29/20.
//

import UIKit
import SpriteKit
import GameplayKit
//import CoreData

class GameViewController: UIViewController {
    var cdm: CoreDataManager = CoreDataManager()
    var gameSceneClass: GameScene.Type = GameScene.self
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        cdm.deleteAllData(forEntityNamed: "CompletedLevel")
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CompletedLevel")
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//        let context = ( UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
//
//        do {
//            try CoreDataManager().persistentContainer.viewContext.execute(deleteRequest)
//        } catch let error as NSError {
//            // TODO: handle the error
//        }
//
//        let dictionary = defaults.dictionaryRepresentation()
//
//        dictionary.keys.forEach { key in
//            defaults.removeObject(forKey: key)
//        }
        
        presentMainMenu()
    }
    
    func presentMainMenu() {
        if let view = self.view as! SKView? {
            if let scene = MainMenu(fileNamed: "MainMenu") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                scene.gvc = self
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
        }
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
 
    func presentLevelMenu() {
        self.performSegue(withIdentifier: "showLevelMenu", sender: self)
    }
    
    func presentSkinsMenu() {
        if let view = self.view as! SKView? {
            if let scene = SkinsMenu(fileNamed: "SkinsMenu") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                scene.gvc = self
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
        }
    }
    
    func loadLevel(number: Int) {
        // Grab reference to our SpriteKit view
        guard let skView = self.view as! SKView? else {
            print("Could not get SKView")
            return
        }

        gameSceneClass.level = number

        guard let gameScene: GameScene = gameSceneClass.getLevel(number) else {
            print("Could not load GameScene with level \(number), gameScene \(gameSceneClass)")
            return
        }
                
        gameScene.gvc = self
        
        // Ensure correct aspect mode
        gameScene.scaleMode = .aspectFill

        // Show debug
//        skView.showsPhysics = true
//        skView.showsDrawCount = true
//        skView.showsFPS = true

        // Start game scene
        skView.presentScene(gameScene)
    }
    
}
