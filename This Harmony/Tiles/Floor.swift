//
//  Floor.swift
//  This Harmony
//
//  Created by Mary Paskhaver on 12/31/20.
//

import Foundation
import SpriteKit

class Floor: Tile {
    var player: Player?
    var crate: Crate?
    var laserBeams: [LaserBeam] = [LaserBeam]()

    init() {
        let defaultTexture: SKTexture = SKTexture(imageNamed: Floor.constants.getLevelTheme().floorImage)

        super.init(texture: defaultTexture, name: Constants.TileNames.floor.rawValue)
    }
    
    init(withPlayerFloorImage image: String) {
        super.init(texture: SKTexture(imageNamed: image), name: Constants.TileNames.floor.rawValue)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setCrate(to crate: Crate) {
        if crate.isOnStorageArea {
            crate.isOnStorageArea = false
            crate.updateImage()
        }
    
        self.crate = crate
    }
    
    func setCrateToNil() {
        self.crate = nil
    }
  
}
